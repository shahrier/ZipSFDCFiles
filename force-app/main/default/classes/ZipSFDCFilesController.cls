public with sharing class ZipSFDCFilesController {
        
        @AuraEnabled(cacheable=true)
        public static Map<ID, String> getRelatedFilesByRecordId(String recordId) {
        
        List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        
        List<ID> fileIDs = new List<ID>();
        for (ContentDocumentLink docLink : files) {
            fileIDs.add(docLink.ContentDocumentId);
        }

        List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
                                     FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];

        Map<ID, String> mapIdTitle = new Map<ID, String>();
        
        for (ContentVersion docLink : docs) {
            if (docLink.FileExtension != null) {
                mapIdTitle.put(docLink.ContentDocumentId, docLink.Title + '.' + docLink.FileExtension);
            }
            else {
                mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
            }
        }
        
        return mapIdTitle;
    }
}
