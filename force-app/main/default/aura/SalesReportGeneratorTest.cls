//Test Class
@isTest
private class TestUserStory {
    //Test doInit()
    static testMethod void testDoInit(){
        Test.startTest();
        //create a component
        Component cmp = new Component();
        //mock the data
        Entity__c entityRec = new Entity__c();
        List<Entity__c> entities = new List<Entity__c>();
        entities.add(entityRec);
        Test.setMock(Database.queryLocator, entities);
        //invoke doInit
        UserStory.doInit(cmp);
        Test.stopTest();
        //assert
        System.assertEquals(cmp.data, entityRec);
    }
    
    //Test handleOnClick()
    static testMethod void testHandleOnClick(){
        Test.startTest();
        //create a component
        Component cmp = new Component();
        //mock the data
        Entity__c entityRec = new Entity__c();
        List<Entity__c> entities = new List<Entity__c>();
        entities.add(entityRec);
        Test.setMock(Database.queryLocator, entities);
        //invoke handleOnClick
        UserStory.handleOnClick(cmp, new Event());
        Test.stopTest();
        //assert
        System.assertEquals(cmp.data, entityRec);
    }
}