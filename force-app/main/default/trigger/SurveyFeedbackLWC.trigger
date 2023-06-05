trigger surveyResponse on Survey_Response__c (after insert, before update) {
    //Create a set to store distinct survey Ids
    Set<Id> surveyIds = new Set<Id>();
    //Create a map to store all survey responses
    Map<Id, List<Survey_Response__c>> surveyResponses = new Map<Id, List<Survey_Response__c>>();
    //Loop through all the survey responses
    for(Survey_Response__c surveyResponse : Trigger.new) {
        //Add the survey id to the set
        surveyIds.add(surveyResponse.Survey__c);
        //Add the survey response to the map
        if(surveyResponses.containsKey(surveyResponse.Survey__c)) {
            surveyResponses.get(surveyResponse.Survey__c).add(surveyResponse);
        } else {
            List<Survey_Response__c> newList = new List<Survey_Response__c>();
            newList.add(surveyResponse);
            surveyResponses.put(surveyResponse.Survey__c, newList);
        }
    }
    //Query all surveys related to the survey responses
    List<Survey__c> surveys = [SELECT Id, (SELECT Id, Question_Type__c, Question_Choices__c FROM Questions__r) FROM Survey__c WHERE Id IN :surveyIds];
    //Loop through all the surveys
    for(Survey__c survey : surveys) {
        //Loop through all the survey responses
        for(Survey_Response__c surveyResponse : surveyResponses.get(survey.Id)) {
            //Loop through all the questions of the survey
            for(Question__c question : survey.Questions__r) {
                //Check if the question type is text
                if(question.Question_Type__c == 'Text') {
                    //Validate that the survey response contains a response
                    if(String.isBlank(surveyResponse.Response_Text__c)) {
                        surveyResponse.addError('Please provide a response to this question');
                    }
                }
                //Check if the question type is single choice
                else if(question.Question_Type__c == 'Single Choice') {
                    //Validate that the survey response contains a valid answer
                    if(String.isBlank(surveyResponse.Response_Choice__c) || !question.Question_Choices__c.contains(surveyResponse.Response_Choice__c)) {
                        surveyResponse.addError('Please provide a valid response to this question');
                    }
                }
                //Check if the question type is multi choice
                else if(question.Question_Type__c == 'Multi Choice') {
                    //Validate that the survey response contains valid answers
                    if(String.isBlank(surveyResponse.Response_Choices__c)) {
                        surveyResponse.addError('Please provide a valid response to this question');
                    }
                    List<String> responses = surveyResponse.Response_Choices__c.split(',');
                    for(String response : responses) {
                        if(!question.Question_Choices__c.contains(response)) {
                            surveyResponse.addError('Please provide a valid response to this question');
                        }
                    }
                }
                //Check if the question type is rating
                else if(question.Question_Type__c == 'Rating') {
                    //Validate that the survey response contains a rating
                    if(surveyResponse.Response_Rating__c == null) {
                        surveyResponse.addError('Please provide a valid response to this question');
                    }
                }
            }
        }
    }
}