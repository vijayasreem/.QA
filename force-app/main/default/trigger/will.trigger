with the selected answers

trigger SurveyResponseTrigger on Survey_Response__c (after insert, after update) {

Set<Id> surveyQuestionIds = new Set<Id>();
Set<Id> surveyQuestionChoiceIds = new Set<Id>();
Set<Id> surveyIds = new Set<Id>();

if(Trigger.isAfter && Trigger.isInsert){
  for(Survey_Response__c surveyResponse : Trigger.new){
    surveyQuestionIds.add(surveyResponse.Survey_Question__c);
    surveyIds.add(surveyResponse.Survey__c);
  }
}

if(Trigger.isAfter && Trigger.isUpdate){
  for(Survey_Response__c surveyResponse : Trigger.new){
    if(Trigger.oldMap.get(surveyResponse.Id).Survey_Question__c != surveyResponse.Survey_Question__c){
      surveyQuestionIds.add(surveyResponse.Survey_Question__c);
    }
    if(Trigger.oldMap.get(surveyResponse.Id).Survey__c != surveyResponse.Survey__c){
      surveyIds.add(surveyResponse.Survey__c);
    }
  }
}

List<Survey_Question__c> surveyQuestions = [SELECT Id, Question_Type__c, (SELECT Id, Question_Choice__c FROM Survey_Question_Choices__r) FROM Survey_Question__c WHERE Id IN :surveyQuestionIds];

for(Survey_Question__c sq : surveyQuestions){
    if(sq.Question_Type__c == 'Single Choice' || sq.Question_Type__c == 'Multi Choice' || sq.Question_Type__c == 'Rating'){
        for(Survey_Question_Choices__c sqc : sq.Survey_Question_Choices__r){
            surveyQuestionChoiceIds.add(sqc.Id);
        }
    }
}

Map<Id, Survey__c> surveysMap = new Map<Id, Survey__c>([SELECT Id, Name, (SELECT Id, Question__c FROM Survey_Questions__r) FROM Survey__c WHERE Id IN :surveyIds]);

List<Survey_Question_Choices__c> surveyQuestionChoices = [SELECT Id, Question_Choice__c FROM Survey_Question_Choices__c WHERE Id IN :surveyQuestionChoiceIds];

Map<Id, List<String>> surveyQuestionChoicesMap = new Map<Id, List<String>>();

for(Survey__c survey : surveysMap.values()){
    for(Survey_Questions__c sq : survey.Survey_Questions__r){
        List<String> choices = new List<String>();
        for(Survey_Question_Choices__c sqc : surveyQuestionChoices){
            if(sqc.Question_Choice__c == sq.Question__c){
                choices.add(sqc.Question_Choice__c);
            }
        }
        surveyQuestionChoicesMap.put(sq.Id, choices);
    }
}

// Save the survey response
if(Trigger.isAfter && Trigger.isInsert){
  for(Survey_Response__c surveyResponse : Trigger.new){
    if(surveyQuestionChoicesMap.containsKey(surveyResponse.Survey_Question__c)){
      List<String> choices = surveyQuestionChoicesMap.get(surveyResponse.Survey_Question__c);
      if(choices.contains(surveyResponse.Answer__c)){
        surveyResponse.Response_Status__c = 'Completed';
      }
    }
  }
  update Trigger.new;
}

if(Trigger.isAfter && Trigger.isUpdate){
  for(Survey_Response__c surveyResponse : Trigger.new){
    if(surveyQuestionChoicesMap.containsKey(surveyResponse.Survey_Question__c)){
      List<String> choices = surveyQuestionChoicesMap.get(surveyResponse.Survey_Question__c);
      if(choices.contains(surveyResponse.Answer__c)){
        surveyResponse.Response_Status__c = 'Completed';
      }
    }
  }
  update Trigger.new;
}

}