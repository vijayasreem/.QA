trigger SurveyResponseTrigger on Survey_Response__c (after insert, after update) {
    //Create a list of survey question ids
    List<Id> surveyQuestionIds = new List<Id>();
    //Create a map of survey response records
    Map<Id, Survey_Response__c> surveyResponseMap = new Map<Id, Survey_Response__c>();
    //Loop through each survey response record
    for(Survey_Response__c surveyResponse : Trigger.New){
        //Add the survey question id to the list
        surveyQuestionIds.add(surveyResponse.Survey_Question__c);
        //Add the survey response record to the map
        surveyResponseMap.put(surveyResponse.Id, surveyResponse);
    }
    //Query the survey questions related to the survey response records
    List<Survey_Question__c> surveyQuestions = [SELECT Id, Type__c FROM Survey_Question__c WHERE Id IN :surveyQuestionIds];
    //Create a map of survey question and type
    Map<Id, String> surveyQuestionMap = new Map<Id, String>();
    //Loop through each survey question
    for(Survey_Question__c surveyQuestion : surveyQuestions){
        //Add the survey question and type to the map
        surveyQuestionMap.put(surveyQuestion.Id, surveyQuestion.Type__c);
    }
    //Create a list of survey response choice records
    List<Survey_Response_Choice__c> surveyResponseChoices = new List<Survey_Response_Choice__c>();
    //Loop through each survey response record
    for(Survey_Response__c surveyResponse : Trigger.New){
        //Check if the survey question type is 'Text'
        if(surveyQuestionMap.get(surveyResponse.Survey_Question__c) == 'Text'){
            //Create a survey response choice record
            Survey_Response_Choice__c surveyResponseChoice = new Survey_Response_Choice__c();
            //Set the survey response and text answer fields
            surveyResponseChoice.Survey_Response__c = surveyResponse.Id;
            surveyResponseChoice.Text_Answer__c = surveyResponse.Text_Answer__c;
            //Add the survey response choice to the list
            surveyResponseChoices.add(surveyResponseChoice);
        }else{
            //Query the survey question choices related to the survey response record
            List<Survey_Question_Choice__c> surveyQuestionChoices = [SELECT Id, Survey_Question__c FROM Survey_Question_Choice__c WHERE Survey_Question__c = :surveyResponse.Survey_Question__c];
            //Loop through each survey question choice
            for(Survey_Question_Choice__c surveyQuestionChoice : surveyQuestionChoices){
                //Check if the survey question type is 'Single Choice' and the survey response answer contains the survey question choice
                if(surveyQuestionMap.get(surveyResponse.Survey_Question__c) == 'Single Choice' && surveyResponse.Single_Choice_Answer__c.contains(surveyQuestionChoice.Id)){
                    //Create a survey response choice record
                    Survey_Response_Choice__c surveyResponseChoice = new Survey_Response_Choice__c();
                    //Set the survey response and survey question choice fields
                    surveyResponseChoice.Survey_Response__c = surveyResponse.Id;
                    surveyResponseChoice.Survey_Question_Choice__c = surveyQuestionChoice.Id;
                    //Add the survey response choice to the list
                    surveyResponseChoices.add(surveyResponseChoice);
                }
                //Check if the survey question type is 'Multi Choice' and the survey response answer contains the survey question choice
                else if(surveyQuestionMap.get(surveyResponse.Survey_Question__c) == 'Multi Choice' && surveyResponse.Multi_Choice_Answer__c.contains(surveyQuestionChoice.Id)){
                    //Create a survey response choice record
                    Survey_Response_Choice__c surveyResponseChoice = new Survey_Response_Choice__c();
                    //Set the survey response and survey question choice fields
                    surveyResponseChoice.Survey_Response__c = surveyResponse.Id;
                    surveyResponseChoice.Survey_Question_Choice__c = surveyQuestionChoice.Id;
                    //Add the survey response choice to the list
                    surveyResponseChoices.add(surveyResponseChoice);
                }
                //Check if the survey question type is 'Rating'
                else if(surveyQuestionMap.