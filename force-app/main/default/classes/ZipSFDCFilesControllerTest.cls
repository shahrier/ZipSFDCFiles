@isTest
public class ZipSFDCFilesControllerTest {

    @testSetup
    static void setup() {
        Account testAccount = new Account(Name = 'Test School', RecordTypeId = Account.SObjectTYpe.getDescribe().getRecordTypeInfosByName().get('School').RecordTypeId);   
        insert testAccount; 
        Contact testContact = TestingUtils.createContacts(1, 'test', testAccount.Id, true)[0];
        List<ContentDocumentLink> files = TestingUtils.createContectDocuments(5, testContact.Id);
    }
    
    static testMethod void getRelatedFilesByRecordIdTest() {
        
        Contact c = [SELECT Id FROM Contact LIMIT 1]; 
        Map<ID, String> files = ZipSFDCFilesController.getRelatedFilesByRecordId(c.id);
        
        System.assert(files.size() == 5, 'An incorrect number of docs has been returned.');
    }
}