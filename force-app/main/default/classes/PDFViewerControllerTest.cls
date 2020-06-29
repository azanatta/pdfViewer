/**
 * Created by albertozanatta on 29.06.20.
 */

@IsTest
private class PDFViewerControllerTest {
    @IsTest
    static void testRelatedFilesOfLead() {
        Lead l = ObjectFactory.createLead();
        insert l;

        String fileTitle = SharedFunctions.generateRandomString(8);

        ContentVersion cVersion = new ContentVersion(
                ContentLocation = 'S',
                PathOnClient = SharedFunctions.generateRandomString(5)+'.pdf',
                Title = fileTitle,
                VersionData = EncodingUtil.base64Decode('test body')
        );
        insert cVersion;
        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;

        ContentDocumentLink cDocLink = new ContentDocumentLink(
                ContentDocumentId = contentDocumentId,
                LinkedEntityId = l.Id,
                ShareType = 'V',
                Visibility = 'AllUsers'
        );
        insert cDocLink;

        Map<Id, String> relatedFiles = PDFViewerController.getRelatedFilesByRecordId(l.Id);
        System.assertEquals(fileTitle, relatedFiles.get(contentDocumentId));
    }
}
