public with sharing class CarouselController {
	@AuraEnabled(Cacheable=true)
    public static List<String> main(Id caseId){
        return setUrlImgMethod(caseId);
    }
    public static List<String> setUrlImgMethod(Id caseId){
		List<String> urlImg = new List<String>();
        list<id> lstConDocs = new list<id>();
        
        for(ContentDocumentLink cntLink : [Select Id, ContentDocumentId 
                                           From ContentDocumentLink 
                                           Where LinkedEntityId =:caseId]) {
            lstConDocs.add(cntLink.ContentDocumentId);
        }
        
        list<ContentVersion> conVerDoc = [SELECT Id, ContentBodyId, FileExtension
                                          FROM ContentVersion 
                                          WHERE ContentDocumentId IN :lstConDocs];
        
        String url;
        String fileExtension; //Capitalize()
        String convVerId; //left(15)
        String conBodyId; //left(15)
        
        for(ContentVersion conVer: conVerDoc){
            fileExtension = conVer.FileExtension;
            convVerId = conVer.Id;
			conBodyId = conVer.ContentBodyId;
            
            url = 'https://senla-cf-dev-ed--c.documentforce.com/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_'
                + fileExtension.Capitalize() +'&versionId='
                + convVerId.left(15) +'&operationContext=CHATTER&contentId='
                + conBodyId.left(15) ;
            
            urlImg.add(url);
        }
        
        return urlImg;
    }
}