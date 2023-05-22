// Salesforce Unit Tests
@isTest
private class InstituteUpdateStatusTest {
    @isTest static void testUpdateStatus() {
        // Create test data
        Institute__c inst = new Institute__c(Name='Test Institute');
        insert inst;
        List<Student__c> studentList = new List<Student__c>();
        for(Integer i=0; i<5; i++) {
            Student__c student = new Student__c(Name='Test Student ' + i, Institute__c=inst.Id, 
                                                Status__c='Active', CreatedDate=Date.Today().addDays(-31));
            studentList.add(student);
        }
        insert studentList;

        // Call the method to test
        List<Id> instituteIds = new List<Id>{inst.Id};
        InstituteUpdateStatus.UpdateStatus(instituteIds);

        // Verify that the records were updated
        List<Student__c> updatedStudentList = [SELECT Id, Status__c FROM Student__c 
                                               WHERE Institute__c IN :instituteIds];
        System.assertEquals(updatedStudentList.size(), 5);
        for(Student__c stu : updatedStudentList) {
            System.assertEquals(stu.Status__c, 'Inactive');
        }
    }
}