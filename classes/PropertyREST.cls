/**
 * Created by booka on 13.10.2022.
 */
@RestResource(urlMapping='/Property/v1/*')
global class PropertyREST {

    @HttpGet
    global static String getProperty() {

        String reply;
        String path = RestContext.request.requestURI.substringAfterLast('v1/');

        if (path.contains('by_owner?owner=')) reply = getPropertiesByOwner(path.substringAfterLast('by_owner?owner='));
        else if (path.contains('report/')) {
            reply = getDeals(
                    path.substringAfterLast('report/').substringBefore('?'),
                    path.substringAfterLast('startDate=').substringBefore('&'),
                    path.substringAfterLast('endDate=').substringBefore('&'),
                    path.substringAfterLast('dealType='));
        }
        else reply = 'Bad path';

        return reply;
    }

    @HttpPost
    global static Property__c createProperty() {
        PropertyManager.PropertyWrapper wrapper = (PropertyManager.PropertyWrapper)
                JSON.deserialize(RestContext.request.requestBody.toString(), PropertyManager.PropertyWrapper.class);

        return PropertyManager.createProperty(wrapper, true);
    }

    @HttpPut
    global static String updatePropertyOwner() {
        Utils.UpdatePropertyOwner wrapPut = (Utils.UpdatePropertyOwner)
                JSON.deserialize(RestContext.request.requestBody.toString(), Utils.UpdatePropertyOwner.class);

        Id ownerID = [SELECT Owner__c FROM Property__c WHERE Id = :wrapPut.propertyId].Owner__c;
        Contact owner = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id =:ownerID];

        owner.Id = String.isNotEmpty(wrapPut.owner.sfId) ? wrapPut.owner.sfId : owner.Id;
        owner.FirstName = String.isNotEmpty(wrapPut.owner.firstName) ? wrapPut.owner.firstName : owner.FirstName;
        owner.LastName = String.isNotEmpty(wrapPut.owner.lastName) ? wrapPut.owner.lastName : owner.LastName;
        owner.Email = String.isNotEmpty(wrapPut.owner.email) ? wrapPut.owner.email : owner.Email;

        update owner;
        return JSON.serialize(owner);
    }

    private static String getDeals(String propertyId, String startDate, String endDate, String dealType) {
        Date startRent = Date.valueOf(startDate);
        Date endRent = Date.valueOf(endDate);

        List<Deal__c> deals = [
                SELECT Id, Buyer__c, RecordTypeId, Property__c, Seller__c,
                        Seller__r.Email, Seller__r.LastName, Seller__r.FirstName, Transaction_amount_rent__c
                FROM Deal__c
                WHERE Property__c =: propertyId
                AND RecordTypeId = :dealType
                AND Rental_start__c >= :startRent
                AND End_of_lease__c <= :endRent];

        Utils.Response response = new Utils.Response(startRent, endRent, deals);

        return JSON.serialize(response, true);
    }

    private static String getPropertiesByOwner(Id ownerId) {
        List<PropertyManager.PropertyWrapper> props = new List<PropertyManager.PropertyWrapper>();

        List<Property__c> properties = [
                SELECT Owner__c, Address__c, City__c, Country__c, Rent_price__c, Selling_Price__c
                FROM Property__c
                WHERE Id =: ownerId];

        for (Property__c property : properties) {
            PropertyManager.PropertyWrapper wrapper = new PropertyManager.PropertyWrapper();
            wrapper.country = property.Country__c;
            wrapper.city = property.City__c;
            wrapper.owner = property.Owner__c;
            wrapper.rent = property.Rent_price__c;
            wrapper.selling = property.Selling_Price__c;
            wrapper.address = property.Address__c;
            props.add(wrapper);
        }

        return JSON.serialize(props, true);
    }
}