// Apex Class to automatically update the status of related Student__c records to inactive if their Status__c was created more than 30 days ago
public class InstituteUpdateStatus {
  public static void UpdateStatus (List<Id> instituteIds) {
    // Get list of related Student__c records
    List<Student__c> studentList = [SELECT Id, Status__c, CreatedDate 
                                   FROM Student__c 
                                   WHERE Institute__c IN :instituteIds];
    
    // Create a list of records to update
    List<Student__c> studentsToUpdate = new List<Student__c>();
    
    // Iterate through the list of related Student__c records
    for (Student__c student : studentList) {
      // Calculate the difference between the current date and the CreatedDate of the Student__c record
      Integer daysDiff = Date.daysBetween(student.CreatedDate, Date.Today());
      
      // If the difference is greater than 30 days, and the Status__c is not 'Inactive'
      if (daysDiff > 30 && student.Status__c != 'Inactive') {
        // Update the Status__c to 'Inactive'
        student.Status__c = 'Inactive';
        // Add the record to the list of records to update
        studentsToUpdate.add(student);
      }
    }
    // Update the list of records
    update studentsToUpdate;
  }
}