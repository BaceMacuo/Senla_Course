/**
 * Created by booka on 10.10.2022.
 */

public with sharing class LocationWrapper {
    public String country;
    public String city;
    public String address;
    public String latitude;
    public String longitude;

    public LocationWrapper(String country, String city, String address){
        this.country = country;
        this.city = city;
        this.address = address;
    }

    public LocationWrapper(String country, String city, String address, String latitude, String longitude){
        this.country = country;
        this.city = city;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
    }
}