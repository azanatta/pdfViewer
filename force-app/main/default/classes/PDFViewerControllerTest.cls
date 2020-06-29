/**
 * Created by albertozanatta on 29.06.20.
 */

@IsTest
private class PDFViewerControllerTest {
    @IsTest
    static void testRelatedFilesOfLead() {
        Lead lead = new Lead(
            LastName = 'Test Lead'    
        );
        insert lead;

        String fileTitle = 'Test File Title';

        ContentVersion cVersion = new ContentVersion(
                ContentLocation = 'S',
                PathOnClient = 'testFileName.pdf',
                Title = fileTitle,
                VersionData = EncodingUtil.base64Decode('test file body')
        );
        insert cVersion;
        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;

        ContentDocumentLink cDocLink = new ContentDocumentLink(
                ContentDocumentId = contentDocumentId,
                LinkedEntityId = lead.Id,
                ShareType = 'V',
                Visibility = 'AllUsers'
        );
        insert cDocLink;

        Map<Id, String> relatedFiles = PDFViewerController.getRelatedFilesByRecordId(l.Id);
        System.assertEquals(fileTitle, relatedFiles.get(contentDocumentId));
    }
}
