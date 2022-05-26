package ca.bc.gov.nrs.api.v1.model;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.time.LocalDate;

@Entity
@Table(name = "MTA_COAL_LICENSE")
public class MTACoalLicense extends PanacheEntityBase {

  @Id
  @Column(name = "TENURE_NUMBER_ID", unique = true, updatable = false)
  Integer tenureNumberId;

  @Column(name = "LOCATION_DESCRIPTION")
  String locationDescription;

  @Column(name = "APPLICATION_ID")
  Integer applicationId;

  @Column(name = "LAND_DISTRICT_CHR")
  String landDistrictChr;

  @Column(name = "REGION_CODE")
  String regionCode;

  @Column(name = "RENTAL_ISSUE_DATE")
  LocalDate rentalIssueDate;

  @Column(name = "TERM_EXPIRY_DATE")
  LocalDate termExpiryDate;


  @Override
  public String toString() {
    return "MTACoalLicense{" +
      "tenureNumberId=" + tenureNumberId +
      ", locationDescription='" + locationDescription + '\'' +
      ", applicationId=" + applicationId +
      ", landDistrictChr='" + landDistrictChr + '\'' +
      ", regionCode='" + regionCode + '\'' +
      ", rentalIssueDate=" + rentalIssueDate +
      ", termExpiryDate=" + termExpiryDate +
      '}';
  }

  public Integer getTenureNumberId() {
    return tenureNumberId;
  }

  public void setTenureNumberId(Integer tenureNumberId) {
    this.tenureNumberId = tenureNumberId;
  }

  public String getLocationDescription() {
    return locationDescription;
  }

  public void setLocationDescription(String locationDescription) {
    this.locationDescription = locationDescription;
  }

  public Integer getApplicationId() {
    return applicationId;
  }

  public void setApplicationId(Integer applicationId) {
    this.applicationId = applicationId;
  }

  public String getLandDistrictChr() {
    return landDistrictChr;
  }

  public void setLandDistrictChr(String landDistrictChr) {
    this.landDistrictChr = landDistrictChr;
  }

  public String getRegionCode() {
    return regionCode;
  }

  public void setRegionCode(String regionCode) {
    this.regionCode = regionCode;
  }

  public LocalDate getRentalIssueDate() {
    return rentalIssueDate;
  }

  public void setRentalIssueDate(LocalDate rentalIssueDate) {
    this.rentalIssueDate = rentalIssueDate;
  }

  public LocalDate getTermExpiryDate() {
    return termExpiryDate;
  }

  public void setTermExpiryDate(LocalDate termExpiryDate) {
    this.termExpiryDate = termExpiryDate;
  }

}
