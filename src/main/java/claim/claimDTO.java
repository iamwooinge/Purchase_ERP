package claim;

public class claimDTO {

   String claim_no;
   String claim_date;
   String product_no;
   String employee_no;
   int product_amount;
   int product_standard;
   String product_unit;
   String claim_state;
   
   public String getClaim_no() {
      return claim_no;
   }
   public void setClaim_no(String claim_no) {
      this.claim_no = claim_no;
   }
   public String getClaim_date() {
      return claim_date;
   }
   public void setClaim_date(String claim_date) {
      this.claim_date = claim_date;
   }
   public String getProduct_no() {
      return product_no;
   }
   public void setProduct_no(String product_no) {
      this.product_no = product_no;
   }
   public String getEmployee_no() {
      return employee_no;
   }
   public void setEmployee_no(String employee_no) {
      this.employee_no = employee_no;
   }
   public int getProduct_amount() {
      return product_amount;
   }
   public void setProduct_amount(int product_amount) {
      this.product_amount = product_amount;
   }
   public int getProduct_standard() {
      return product_standard;
   }
   public void setProduct_standard(int product_standard) {
      this.product_standard = product_standard;
   }
   public String getProduct_unit() {
      return product_unit;
   }
   public void setProduct_unit(String product_unit) {
      this.product_unit = product_unit;
   }
   public String getClaim_state() {
      return claim_state;
   }
   public void setClaim_state(String claim_state) {
      this.claim_state = claim_state;
   }

}