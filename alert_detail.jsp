<%-- 
    Document   : alert_detail
    Created on : Feb 21, 2012, 11:48:38 AM
    Author     : CD2D1
--%> 
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>    
<%  
//--------------------------- First Date Of Last Month ----------------------------------------
         Calendar cal1 = Calendar.getInstance(); 
         DateFormat lastday_m= new SimpleDateFormat("yyyy-MM-dd");  
         cal1.set(Calendar.DAY_OF_MONTH,1);
         cal1.add(Calendar.DAY_OF_MONTH, -1);
         String lastdaydt_M=lastday_m.format(cal1.getTime());        

          String date[]=lastdaydt_M.split("-");         
          String lastyeardate="";
          String datey[]=lastdaydt.split("-");
          lastyeardate=(datey[0]);        
          String lastm_frstdt=lastyeardate+"-"+date[1]+"-"+"01"; 
          
//------------------------------ Current Year First Date ------------------------------------------
          Calendar cld = Calendar.getInstance();
          DateFormat lastday2= new SimpleDateFormat("yyyy-MM-dd");
          cld.set(Calendar.DAY_OF_YEAR,1); //first day of the year. 
          cld.add(Calendar.YEAR,0);
          String cur_yrfdt=lastday2.format(cld.getTime());        
          
//------------------------------- Last Year First Date --------------------------------------------          
          Calendar cld_1 = Calendar.getInstance();
          DateFormat lastday3= new SimpleDateFormat("yyyy-MM-dd");
          cld_1.set(Calendar.DAY_OF_YEAR,1); //first day of the year. 
          cld_1.add(Calendar.YEAR,-1);
          String last_yrfdt=lastday3.format(cld_1.getTime());               
//------------------------------- Querter Date -----------------------------------------------------
          String[] dq=dateNow.split("-");
          String Q1_fdate=dq[0]+"-"+"01"+"-"+"01";
          String Q2_fdate=dq[0]+"-"+"04"+"-"+"01";
          String Q3_fdate=dq[0]+"-"+"07"+"-"+"01";
          //String[] ql=last_yrfdt.split("-");
          String Q4_fdate=dq[0]+"-"+"10"+"-"+"01";
                    
//===================================================================================================//
       String uname="";
        uname=session.getAttribute("username").toString();
        int count=1;
        double arv_minamt_qtr=0,arv_avgamt_qtr=0;
        double dis_minm=0,dis_avgm=0,iss_minmeter=0.0,iss_avgamt=0,st_mincost=0.0,st_avgcost=0.0;
        double DIS_max=0.0,DIS_avg=0.0,DIS_min=0.0,WAT_max=0.0,WAT_avg=0.0,WAT_min=0.0,chemical_avgamt=0.0,chemical_max=0.0,caol_avgamt=0.0,coal_max=0.0;    
        double boiler_minamt=0.0,boiler_avgamt=0.0,total_boilercost=0.0,boiler_max=0.0,other_minamt=0.0, other_avgamt=0.0;
        double emp_minamt=0.0, emp_avgmeter=0.0,bill_min=0.0, ETP_max=0.0,ETP_avg=0.0,ETP_min=0.0, bill_avg=0.0,rp_minmeter=0.0, rp_avgmeter=0.0,greybalanced=0.0,greybalanced1=0.0, geyissue=0.0, productionmeter=0.0, bsrmeter=0.0, machineproduction=0.0, pendingpayment=0.0, billingpayment=0.0;
        double rev_minamt=0.0, rev_avgamt=0.0,bsr_minamt=0.0,bsr_avgamt=0.0,bale_minamt=0.0,bale_avgamt=0.0;
    //================================================= Grey ==============================================  
        
        double ags_minmeter=0.0, ags_avgmeter=0.0;
        int ags_indaily=0, ags_inmonthly=0, ags_indate=0,cont_m=0; 
        String ags_indays="";
        ResultSet rs_greyavgmin=st.executeQuery("SELECT ags_minmeter, ags_avgmeter, ags_indaily, ags_indays, ags_inmonthly, ags_indate FROM et_alert_greystock");
        if(rs_greyavgmin.next()){
            ags_minmeter=rs_greyavgmin.getDouble("ags_minmeter");
            ags_avgmeter=rs_greyavgmin.getDouble("ags_avgmeter");
            ags_indaily=rs_greyavgmin.getInt("ags_indaily");            
            ags_indays=rs_greyavgmin.getString("ags_indays");
            ags_inmonthly=rs_greyavgmin.getInt("ags_inmonthly");            
            ags_indate=rs_greyavgmin.getInt("ags_indate");
         }
            double prd_minmeter=0.0, prg_avgmeter=0.0;
            int prd_indaily=0, prd_inmonthly=0, prd_indate=0,cont_p=0,cont_pp=0; 
            String prd_indays="";
            ResultSet rs_prdavgmin=st.executeQuery("SELECT aprd_minmeter, aprd_avgmeter, aprd_indaily, aprd_indays, aprd_inmonthly, aprd_indates FROM et_alert_production");
            if(rs_prdavgmin.next()){
            prd_minmeter=rs_prdavgmin.getDouble("aprd_minmeter");
            prg_avgmeter=rs_prdavgmin.getDouble("aprd_avgmeter");
            prd_indaily=rs_prdavgmin.getInt("aprd_indaily");            
            prd_indays=rs_prdavgmin.getString("aprd_indays");
            prd_inmonthly=rs_prdavgmin.getInt("aprd_inmonthly");            
            prd_indate=rs_prdavgmin.getInt("aprd_indates");
         }
        
  //<!-------------------------------------------  End Of Production-------------------------------------------------->      
         String role_name="", role_id="";
         String d="1";
         int cont=0; String monthfirstdt="";   
         String dd[]=dateNow.split("-");
         monthfirstdt=dd[0]+"-"+dd[1]+"-"+d;
         ResultSet rs_loguserrole=st.executeQuery("SELECT role_name,A.role_id FROM et_role as A, et_user_detail as B WHERE A.role_id=B.role_id AND user_name='"+uname+"'");
         if(rs_loguserrole.next()){
         role_name=rs_loguserrole.getString("role_name");   
         role_id=rs_loguserrole.getString("role_id");                    
         }        
//Manager Alert-----------------------------------------------------------------------
        
if(role_name.equals("Manager")){            
    if(ags_indaily==1){        
        ResultSet rs_status=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Grey stock meter'");
        while(rs_status.next()){ cont++; }
        if(cont==0){ 
        ResultSet rs_geymeter_d=st.executeQuery("SELECT SUM(pcsdetail_actualmeter) as pcsdetail_actualmeter FROM et_grey_pcsdetail WHERE pcsdetail_status='GB' AND pcsdetail_modified='"+lastdaydt+"'");
        if(rs_geymeter_d.next()){ greybalanced=rs_geymeter_d.getDouble("pcsdetail_actualmeter"); }
        if(greybalanced<=ags_avgmeter)
                 {  
                 String query = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,greybalanced);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Grey stock meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();     
                    }   
              } //cnt          
          }//daily
           else if(!ags_indays.equals("")){}//indays
           if(ags_indate==0){}//Perticular_date
    
           else if(ags_inmonthly==1){
           if(dateNow.equals(monthfirstdt)){
           ResultSet rs_status_m=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Grey stock meter'");
           while(rs_status_m.next()){ cont_m++;}
           if(cont_m==0){
           ResultSet rs_geymeter_dd=st.executeQuery("SELECT SUM(pcsdetail_actualmeter) as pcsdetail_actualmeter FROM et_grey_pcsdetail WHERE pcsdetail_modified BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"' AND pcsdetail_status='GB'");
           if(rs_geymeter_dd.next()){ greybalanced1=rs_geymeter_dd.getDouble("pcsdetail_actualmeter"); }
           if(greybalanced1<=ags_avgmeter )
            {  
                  String query1 = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query1); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,greybalanced1);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Grey stock meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate(); 
             } 
             }  //cont_m     
             }//if of first date
           }//monthly
 //------------------------------------------------- Production ---------------------------------------------------   
        if(prd_indaily==1){        
        ResultSet rs_status=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Production stock meter'");
        while(rs_status.next()){ cont_p++;}
        if(cont_p==0){    
    
        ResultSet rs_production_d=st.executeQuery("SELECT SUM(finished_meter) as finished_meter FROM et_finshing_material WHERE finished_status='PCK' AND grey_finished_date='"+lastdaydt+"'");
        if(rs_production_d.next()){
        productionmeter=rs_production_d.getDouble("finished_meter");}
        if(productionmeter<=prg_avgmeter)
               {
                  String query_p ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_p); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,productionmeter);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Production stock meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// contp
           }
        
        else if(prd_inmonthly==1){ 
        if(dateNow.equals(monthfirstdt)){
        ResultSet rs_status_m=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Production stock meter'");
        while(rs_status_m.next()){ cont_pp++;}

        if(cont_pp==0){ 
        ResultSet rs_production_d=st.executeQuery("SELECT SUM(finished_meter) as finished_meter FROM et_finshing_material WHERE grey_finished_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'AND finished_status='PCK'");
        if(rs_production_d.next()){ productionmeter=rs_production_d.getDouble("finished_meter");}
        if(productionmeter<=prg_avgmeter)
                 {
              String query_p ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_p); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,productionmeter);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Production stock meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                  }              
                 }//contpp
             }//if mon first date
            }//monthly if   
//---------- End Production ----------------------------------------
// Reprocess.................................................
            double reprocess_meter=0;
            int rp_indaily=0, rp_inmonthly=0, rp_indate=0,cont_rp=0,cont_rpp=0; 
            String rp_indays="";
            ResultSet rs_rpavgmin=st.executeQuery("SELECT arp_minmeter, arp_avgmeter, arp_indaily, arp_inday, arp_inmonthly, arp_indates FROM et_alert_reprocess");
            if(rs_rpavgmin.next()){
            rp_minmeter=rs_rpavgmin.getDouble("arp_minmeter");
            rp_avgmeter=rs_rpavgmin.getDouble("arp_avgmeter");
            rp_indaily=rs_rpavgmin.getInt("arp_indaily");            
            rp_indays=rs_rpavgmin.getString("arp_inday");
            rp_inmonthly=rs_rpavgmin.getInt("arp_inmonthly");            
            rp_indate=rs_rpavgmin.getInt("arp_indates");
            }       
      if(rp_indaily==1){            
      ResultSet rs_status=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Reprocess Grey stock meter'");
      while(rs_status.next()){ cont_rp++;}
      if(cont_rp==0){    
     
        ResultSet rs_reprocess_d=st.executeQuery("SELECT SUM(rp_pcdetail_actualmeter) AS rep_tot FROM et_reprocess_pcsdetail WHERE rp_pcdetail_status='GI' AND rp_pcdetail_modified='"+lastdaydt+"'");
        if(rs_reprocess_d.next()){reprocess_meter=rs_reprocess_d.getDouble("rep_tot");}
        if(reprocess_meter<=rp_avgmeter)
              {
              String query_rp ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_rp); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,reprocess_meter);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Reprocess Grey stock meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// contrp            
           }
       else if(rp_inmonthly==1){ 
           if(dateNow.equals(monthfirstdt)){  
              cont_rpp=0;
              ResultSet rs_status_m=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Reprocess Grey stock meter'");
              while(rs_status_m.next()){ cont_rpp++;}

         if(cont_rpp==0){ 
         ResultSet rs_production_d=st.executeQuery("SELECT SUM(finished_meter) as finished_meter FROM et_finshing_material WHERE grey_finished_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'AND finished_status='PCK'");
         if(rs_production_d.next()){
         productionmeter=rs_production_d.getDouble("finished_meter");}
         if(productionmeter<=rp_avgmeter)
                 {
              String query_p ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_p); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,productionmeter);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Reprocess Grey stock meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                  }        
                        }              
                 }//contpp              
            }//monthly if
 //-------------------------------- Billing--------------------------------------------
            double bil_amt=0;
            int bill_indaily=0, bill_inmonthly=0, bill_indate=0,bill_count=0;  
            String bill_indays="";
            ResultSet rs_bill=st.executeQuery("SELECT * FROM et_alert_billing");
            if(rs_bill.next()){
            bill_min=rs_bill.getDouble("abill_minamt");
            bill_avg=rs_bill.getDouble("abill_avgamt");
            bill_indaily=rs_bill.getInt("abill_indaily");            
            bill_indays=rs_bill.getString("abill_inday");
            bill_inmonthly=rs_bill.getInt("abill_inmonthly");            
            bill_indate=rs_bill.getInt("abill_indate");
            }    
              
        if(bill_indaily==1){ bill_count=0;     
        ResultSet rs_status=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Billing Amount'");
        while(rs_status.next()){ bill_count++;}
        if(bill_count==0){      
        ResultSet rs_bill_m=st.executeQuery("select SUM(billing_amt)AS bill_amt_sum from et_billing_detail WHERE billing_date='"+lastdaydt+"'");
        if(rs_bill_m.next()){ bil_amt=rs_bill_m.getDouble("bill_amt_sum");}     
        if( bil_amt<=bill_avg)
              {
                  String query_bill ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_bill); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,bil_amt);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Billing Amount");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// bill_con
           }
        
         else if(bill_inmonthly==1){
         if(dateNow.equals(monthfirstdt)){
         ResultSet rs_status=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Billing Amount'");
         while(rs_status.next()){ bill_count++;}
         if(bill_count==0){      
         ResultSet rs_bill_m=st.executeQuery("select SUM(billing_amt)AS bill_amt_sum from et_billing_detail WHERE billing_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");
         if(rs_bill_m.next()){ bil_amt=rs_bill_m.getDouble("bill_amt_sum");}        
         if(bil_amt<=bill_avg)
              {
                  String query_bill ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_bill); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,bil_amt);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Billing Amount");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              //wrting comments in this to check git hu working correct or not
                }// contrp
              }
            }//monthly if
 //------------------------------------- Employee Expense---------------------------------------
          double emp_travel=0.0,emp_meal=0.0,emp_fual=0.0,emp_hotel=0.0,emp_phone=0.0,emp_other=0.0,total_empexpence=0.0;
          int cont_emp=0,cont_empp=0;         
          int emp_indaily=0, emp_inmonthly=0, emp_indate=0;  
          String emp_indays="";
          ResultSet rs_rpavgmin_emp=st.executeQuery("SELECT aeo_minamt, aeo_avgamt, aeo_indaily, aeo_inday, aeo_inmonthly, aeo_indates FROM et_alert_empoth WHERE aeo_mode='Employee'");
          if(rs_rpavgmin_emp.next()){
          emp_minamt=rs_rpavgmin_emp.getDouble("aeo_minamt");
          emp_avgmeter=rs_rpavgmin_emp.getDouble("aeo_avgamt");
          emp_indaily=rs_rpavgmin_emp.getInt("aeo_indaily");            
          emp_indays=rs_rpavgmin_emp.getString("aeo_inday");
          emp_inmonthly=rs_rpavgmin_emp.getInt("aeo_inmonthly");            
          emp_indate=rs_rpavgmin_emp.getInt("aeo_indates");
           }                  
 
        if(emp_indaily==1){        
        ResultSet rs_status=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Employee expence amount'");
        while(rs_status.next()){ cont_emp++;}
        if(cont_emp==0){ 
              ResultSet rs_emp_expence=st.executeQuery("SELECT SUM(empex_travelamt) AS trvel,SUM(empex_mealamt) AS meal,SUM(empex_fuelamt) AS fuel,SUM(empex_hotelamt) AS hotel,SUM(empex_phoneamt) AS phone,SUM(empex_otheramt) AS other FROM et_emp_expanditure WHERE empex_date='"+lastdaydt+"'");
              if(rs_emp_expence.next()){ emp_travel=rs_emp_expence.getDouble("trvel");
                                         emp_meal=rs_emp_expence.getDouble("meal");   
                                         emp_fual=rs_emp_expence.getDouble("fuel"); 
                                         emp_hotel=rs_emp_expence.getDouble("hotel"); 
                                         emp_phone=rs_emp_expence.getDouble("phone");
                                         emp_other=rs_emp_expence.getDouble("other");  
                                             }
                                total_empexpence=emp_travel+emp_meal+emp_fual+emp_hotel+emp_phone+emp_other;
              if(total_empexpence>=emp_avgmeter)
                 {  
                  String query_emp = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_emp); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_empexpence);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Employee expence amount");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();     
                    }   
              } //cnt      
           }//daily          
    
   else if(emp_inmonthly==1){  
        ResultSet rs_status_m=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Employee expence amount'");
        while(rs_status_m.next()){ cont_empp++;}
        if(cont_empp==0){
         if(dateNow.equals(monthfirstdt)){
        ResultSet rs_emp_expence=st.executeQuery("SELECT SUM(empex_travelamt) AS trvel,SUM(empex_mealamt) AS meal,SUM(empex_fuelamt) AS fuel,SUM(empex_hotelamt) AS hotel,SUM(empex_phoneamt) AS phone,SUM(empex_otheramt) AS other FROM et_emp_expanditure WHERE empex_date BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'");
        if(rs_emp_expence.next()){ emp_travel=rs_emp_expence.getDouble("trvel");
                                         emp_meal=rs_emp_expence.getDouble("meal");   
                                         emp_fual=rs_emp_expence.getDouble("fuel"); 
                                         emp_hotel=rs_emp_expence.getDouble("hotel"); 
                                         emp_phone=rs_emp_expence.getDouble("phone");
                                       emp_other=rs_emp_expence.getDouble("other");  
                                   }
              total_empexpence=emp_travel+emp_meal+emp_fual+emp_hotel+emp_phone+emp_other;
              if(total_empexpence>=emp_avgmeter)
                 {  
                  String query1 = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query1); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_empexpence);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Employee expence amount");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate(); 
                 }  
               }
              }
            }//monthly  
//--------------------------------------------------- Other Expense ----------------------------------------
            double total_otherexpence=0.0;
            int cont_other=0,cont_otherr=0;          
            int other_indaily=0, other_inmonthly=0, other_indate=0; 
            String other_indays="";
            ResultSet rs_rpavgmin_ot=st.executeQuery("SELECT aeo_minamt, aeo_avgamt, aeo_indaily, aeo_inday, aeo_inmonthly, aeo_indates FROM et_alert_empoth WHERE aeo_mode='Other'");
            if(rs_rpavgmin_ot.next()){
            other_minamt=rs_rpavgmin_ot.getDouble("aeo_minamt");
            other_avgamt=rs_rpavgmin_ot.getDouble("aeo_avgamt");
            other_indaily=rs_rpavgmin_ot.getInt("aeo_indaily");            
            other_indays=rs_rpavgmin_ot.getString("aeo_inday");
            other_inmonthly=rs_rpavgmin_ot.getInt("aeo_inmonthly");            
            other_indate=rs_rpavgmin_ot.getInt("aeo_indates");
         }                         
            
 
 
 if(other_indaily==1){        
         ResultSet rs_status=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Other expence amount'");
         while(rs_status.next()){ cont_other++;}
         if(cont_other==0){ 
         ResultSet rs_other_expence=st.executeQuery("SELECT sum(othex_amt) AS other FROM et_other_expense where othex_created='"+lastdaydt+"'");
         if(rs_other_expence.next()){total_otherexpence=rs_other_expence.getDouble("other");}                                
         if(total_otherexpence>=other_avgamt)
                 {  
                 String query = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_empexpence);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Other expence amount");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();     
                    }   
              } //cnt          
         }//daily          
    
   else if(other_inmonthly==1){ 
   if(dateNow.equals(monthfirstdt)){       
         ResultSet rs_status_m=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Other expence amount'");
         while(rs_status_m.next()){ cont_otherr++;}
         if(cont_otherr==0){
              ResultSet rs_other_expence=st.executeQuery("SELECT sum(othex_amt) AS other FROM et_other_expense where othex_created BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'");
              if(rs_other_expence.next()){ total_otherexpence=rs_other_expence.getDouble("other"); }
              if(total_empexpence>=other_avgamt )
                 {  
                  String query1 = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query1); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_otherexpence);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Other expence amount");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate(); 
                 }  
               }
                 }
            }//monthly
           
    //--------------------------------------------------- consumption of Boiler ----------------------------------------
           int cont_boiler=0,cont_boilerr=0;          
           int boiler_indaily=0, boiler_inmonthly=0, boiler_indate=0; 
           String boiler_indays="";
           ResultSet rs_rpavgmin_boi=st.executeQuery("SELECT acon_mincost, acon_avgcost,acon_maxcost, acon_indaily, acon_inday, acon_inmonthly, acon_indate FROM et_alert_consumption WHERE cate_id='cate_8'");
            if(rs_rpavgmin_boi.next()){
            boiler_minamt=rs_rpavgmin_boi.getDouble("acon_mincost");
            boiler_avgamt=rs_rpavgmin_boi.getDouble("acon_avgcost");
            boiler_max=rs_rpavgmin_boi.getDouble("acon_maxcost");
            boiler_indaily=rs_rpavgmin_boi.getInt("acon_indaily");            
            boiler_indays=rs_rpavgmin_boi.getString("acon_inday");
            boiler_inmonthly=rs_rpavgmin_boi.getInt("acon_inmonthly");            
            boiler_indate=rs_rpavgmin_boi.getInt("acon_indate");
           }                         
            
         if(boiler_indaily==1){        
         ResultSet rs_status_b=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Boiler Consumption'");
         while(rs_status_b.next()){ cont_boiler++;}
         if(cont_boiler==0){ 
         ResultSet rs_boiler_issu=st.executeQuery("SELECT SUM(sissue_amt) AS issue_b FROM  et_store_issue  WHERE cate_id='cate_8' AND sissue_modifieddate='"+lastdaydt+"'");
         if(rs_boiler_issu.next()){total_boilercost=rs_boiler_issu.getDouble("issue_b");}                                
         if(total_boilercost>=boiler_minamt)
                 {  
                 String query = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_boilercost);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Boiler Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();     
                    }   
              } //cnt          
         }//daily           
           
    else if(boiler_inmonthly==1){  
         if(dateNow.equals(monthfirstdt)){
         ResultSet rs_status_bb=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Boiler Consumption'");
         while(rs_status_bb.next()){ cont_boilerr++;}
         if(cont_boilerr==0){
              ResultSet rs_boiler=st.executeQuery("SELECT SUM(sissue_amt) AS issue_bb FROM  et_store_issue  WHERE cate_id='cate_8' AND sissue_modifieddate BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'");
              if(rs_boiler.next()){ total_boilercost=rs_boiler.getDouble("issue_bb"); }
              if(total_boilercost>=boiler_minamt)
                 {  
                  String query1 = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query1); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_boilercost);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Boiler amount");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate(); 
                 }  
               }
                 }
            }//monthly
                     
   //-------------------------------------- Consumption(chemical) ----------------------------------------------      
           
        double total_chemical=0.0,chemical_minamt=0.0;
           int cont_chemical=0,cont_chemicall=0;          
           int chemical_indaily=0, chemical_inmonthly=0, chemical_indate=0; 
           String chemical_indays="";
           ResultSet rs_rpavgmin_che=st.executeQuery("SELECT acon_mincost, acon_avgcost,acon_maxcost, acon_indaily, acon_inday, acon_inmonthly, acon_indate FROM et_alert_consumption WHERE cate_id='cate_3'");
            if(rs_rpavgmin_che.next()){
            chemical_minamt=rs_rpavgmin_che.getDouble("acon_mincost");
            chemical_avgamt=rs_rpavgmin_che.getDouble("acon_avgcost");
            chemical_max=rs_rpavgmin_che.getDouble("acon_maxcost");
            chemical_indaily=rs_rpavgmin_che.getInt("acon_indaily");            
            chemical_indays=rs_rpavgmin_che.getString("acon_inday");
            chemical_inmonthly=rs_rpavgmin_che.getInt("acon_inmonthly");            
            chemical_indate=rs_rpavgmin_che.getInt("acon_indate");
           }                         
            
         if(chemical_indaily==1){        
         ResultSet rs_status_b=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Chemical Consumption'");
         while(rs_status_b.next()){ cont_chemical++;}
         if(cont_chemical==0){ 
         ResultSet rs_chemical_issu=st.executeQuery("SELECT SUM(sissue_amt) AS issue_b FROM  et_store_issue  WHERE cate_id='cate_3' AND sissue_modifieddate='"+lastdaydt+"'");
         if(rs_chemical_issu.next()){total_chemical=rs_chemical_issu.getDouble("issue_b");}                                
         if(total_chemical>=boiler_minamt)
                 {  
                 String query_ch = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_ch); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_chemical);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Chemical Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();     
                    }   
              } //cnt          
         }//daily           
           
        else if(chemical_inmonthly==1){  
       if(dateNow.equals(monthfirstdt)){
         ResultSet rs_status_bb=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date ='"+dateNow+"' AND alert_mode='M' AND alert_for='Chemical Consumption'");
        while(rs_status_bb.next()) { cont_chemicall++;         }
         if(cont_chemicall==0){
              ResultSet rs_chemical=st.executeQuery("SELECT SUM(sissue_amt) AS issue_bb FROM  et_store_issue  WHERE cate_id='cate_3' AND sissue_modifieddate BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'");
              if(rs_chemical.next()){ total_chemical=rs_chemical.getDouble("issue_bb"); }
              if(total_chemical>=boiler_minamt)
                 {  
                  String query_c = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_c); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_chemical);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Chemical Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate(); 
                 }  
               }
                 }
            }//monthly
                        
 //-------------------------------------- Consumption(coal) ----------------------------------------------       
            double total_coal=0.0,coal_minamt=0.0;        
           int cont_coal=0,cont_coall=0;          
           int coal_indaily=0, coal_inmonthly=0, coal_indate=0; 
           String coal_indays="";
           ResultSet rs_rpavgmin_coal=st.executeQuery("SELECT acon_mincost, acon_avgcost,acon_maxcost, acon_indaily, acon_inday, acon_inmonthly, acon_indate FROM et_alert_consumption WHERE cate_id='cate_2'");
            if(rs_rpavgmin_coal.next()){
            coal_minamt=rs_rpavgmin_coal.getDouble("acon_mincost");
            caol_avgamt=rs_rpavgmin_coal.getDouble("acon_avgcost");
            coal_max=rs_rpavgmin_coal.getDouble("acon_maxcost");
            coal_indaily=rs_rpavgmin_coal.getInt("acon_indaily");            
            coal_indays=rs_rpavgmin_coal.getString("acon_inday");
            coal_inmonthly=rs_rpavgmin_coal.getInt("acon_inmonthly");            
            coal_indate=rs_rpavgmin_coal.getInt("acon_indate");
           }                         
            
         if(coal_indaily==1){        
         ResultSet rs_status_coal=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Coal Consumption'");
         while(rs_status_coal.next()){ cont_coal++;}
         if(cont_coal==0){ 
         ResultSet rs_coal_issu=st.executeQuery("SELECT SUM(sissue_amt) AS issue_b FROM  et_store_issue  WHERE cate_id='cate_2' AND sissue_modifieddate='"+lastdaydt+"'");
         if(rs_coal_issu.next()){total_coal=rs_coal_issu.getDouble("issue_b");}                                
         if(total_coal>=coal_minamt)
                 {  
                 String query = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_coal);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Coal Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();     
                    }   
              } //cnt          
         }//daily           
           
    else if(coal_inmonthly==1){ 
    if(dateNow.equals(monthfirstdt)){        
         ResultSet rs_status_bb=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Coal Consumption'");
         while(rs_status_bb.next()){ cont_coall++;}
         if(cont_coall==0){
              ResultSet rs_coal=st.executeQuery("SELECT SUM(sissue_amt) AS issue_bb FROM  et_store_issue  WHERE cate_id='cate_2' AND sissue_modifieddate BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'");
              if(rs_coal.next()){ total_coal=rs_coal.getDouble("issue_bb"); }
              if(total_coal>=coal_minamt)
                 {  
                  String query1 = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query1); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_coal);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Coal Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate(); 
                 }  
               }
                 }
            }//monthly
                     
                     
           
           
//-------------------------------------- Consumption(Etp) ----------------------------------------------
            double ETP_amt=0;
            int ETP_indaily=0, ETP_inmonthly=0, ETP_indate=0,ETP_count=0;  
            String ETP_indays="";
            ResultSet rs_ETP=st.executeQuery("SELECT * FROM et_alert_consumption WHERE cate_id='cate_10'");
            if(rs_ETP.next()){
            ETP_min=rs_ETP.getDouble("acon_mincost");
            ETP_avg=rs_ETP.getDouble("acon_avgcost");
            ETP_max=rs_ETP.getDouble("acon_maxcost");
            ETP_indaily=rs_ETP.getInt("acon_indaily");            
            ETP_indays=rs_ETP.getString("acon_inday");
            ETP_inmonthly=rs_ETP.getInt("acon_inmonthly");            
            ETP_indate=rs_ETP.getInt("acon_indate");
            }    
              
        if(ETP_indaily==1){     
        ResultSet rs_status_ETP=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='ETP Consumption'");
        while(rs_status_ETP.next()){ ETP_count++;}
        if(ETP_count==0){      
        ResultSet rs_ETP_m=st.executeQuery("SELECT sum(sissue_amt) as cons_tot FROM et_store_issue as ssi WHERE cate_id='cate_10' AND ssi.sissue_date='"+lastdaydt+"'");
        if(rs_ETP_m.next()){ ETP_amt=rs_ETP_m.getDouble("cons_tot");}     
        if(ETP_amt>=ETP_min)
              {
                  String query_ETP ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_ETP); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,ETP_amt);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"ETP Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// bill_con
           }
        
         else if(ETP_inmonthly==1){
       if(dateNow.equals(monthfirstdt)){
         ResultSet rs_status_ETP1=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='ETP Consumption'");
         while(rs_status_ETP1.next()){ ETP_count++;}
         if(ETP_count==0){      
         ResultSet rs_ETP_m=st.executeQuery("SELECT sum(sissue_amt) as cons_tot FROM et_store_issue as ssi WHERE cate_id='cate_10' AND ssi.sissue_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");
         if(rs_ETP_m.next()){ ETP_amt=rs_ETP_m.getDouble("cons_tot");}        
         if(ETP_amt>=ETP_min)
              {
                  String query_ETP1 ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_ETP1); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,ETP_amt);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"ETP Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// contrp
               }
            }//monthly if 

//-------------------------------------- Consumption(Diesel) ----------------------------------------------
            double DIS_amt=0;
            int  DIS_indaily=0,DIS_inmonthly=0, DIS_indate=0,DIS_count=0;  
            String DIS_indays="";
            ResultSet rs_DIS=st.executeQuery("SELECT * FROM et_alert_consumption WHERE cate_id='cate_5'");
            if(rs_DIS.next()){
            DIS_min=rs_DIS.getDouble("acon_mincost");
            DIS_avg=rs_DIS.getDouble("acon_avgcost");
            DIS_max=rs_DIS.getDouble("acon_maxcost");
            DIS_indaily=rs_DIS.getInt("acon_indaily");            
            DIS_indays=rs_DIS.getString("acon_inday");
            DIS_inmonthly=rs_DIS.getInt("acon_inmonthly");            
            DIS_indate=rs_DIS.getInt("acon_indate");
            }    
              
        if(DIS_indaily==1){     
        ResultSet rs_status_DIS=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Diesel Consumption'");
        while(rs_status_DIS.next()){ DIS_count++;}
        if(DIS_count==0){      
        ResultSet rs_DIS_m=st.executeQuery("SELECT sum(sissue_amt) as cons_tot FROM et_store_issue as ssi WHERE cate_id='cate_5' AND ssi.sissue_date='"+lastdaydt+"'");
        if(rs_DIS_m.next()){ DIS_amt=rs_DIS_m.getDouble("cons_tot");}     
        if(DIS_amt>=DIS_min)
              {
                  String query_DIS ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_DIS); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,DIS_amt); 
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Diesel Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// bill_con
           }
        
         else if(DIS_inmonthly==1){
         if(dateNow.equals(monthfirstdt)){
         ResultSet rs_status_DIS1=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Diesel Consumption'");
         while(rs_status_DIS1.next()){ DIS_count++;}
         if(DIS_count==0){      
         ResultSet rs_DIS_m=st.executeQuery("SELECT sum(sissue_amt) as cons_tot FROM et_store_issue as ssi WHERE cate_id='cate_5' AND ssi.sissue_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");
         if(rs_DIS_m.next()){ DIS_amt=rs_DIS_m.getDouble("cons_tot");}        
         if(DIS_amt>=DIS_min)
              {
                  String query_DIS1 ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_DIS1);  
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,DIS_amt);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Diesel Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// contrp
             }
            }//monthly if                                                                                                                                                            
//-------------------------------------- Consumption(WATER) ----------------------------------------------
            double WAT_amt=0;
            int  WAT_indaily=0,WAT_inmonthly=0, WAT_indate=0,WAT_count=0;  
            String WAT_indays="";
            ResultSet rs_WAT=st.executeQuery("SELECT * FROM et_alert_consumption WHERE cate_id='cate_1'");
            if(rs_WAT.next()){
            WAT_min=rs_WAT.getDouble("acon_mincost");
            WAT_avg=rs_WAT.getDouble("acon_avgcost");
            WAT_max=rs_WAT.getDouble("acon_maxcost");
            WAT_indaily=rs_WAT.getInt("acon_indaily");            
            WAT_indays=rs_WAT.getString("acon_inday");
            WAT_inmonthly=rs_WAT.getInt("acon_inmonthly");            
            WAT_indate=rs_WAT.getInt("acon_indate");
            }    
              
        if(WAT_indaily==1){     
        ResultSet rs_status_WAT=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Water Consumption'");
        while(rs_status_WAT.next()){ WAT_count++;}
        if(WAT_count==0){      
        ResultSet rs_WAT_m=st.executeQuery("SELECT sum(sissue_amt) as cons_tot FROM et_store_issue as ssi WHERE cate_id='cate_1' AND ssi.sissue_date='"+lastdaydt+"'");
        if(rs_WAT_m.next()){ DIS_amt=rs_WAT_m.getDouble("cons_tot");}     
        if(WAT_amt>=WAT_min)
              {
                  String query_WAT ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_WAT); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,WAT_amt); 
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Water Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// bill_con
           }
        
         else if(WAT_inmonthly==1){
       if(dateNow.equals(monthfirstdt)){
         ResultSet rs_status_WAT1=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Water Consumption'");
         while(rs_status_WAT1.next()){ WAT_count++;}
         if(WAT_count==0){      
         ResultSet rs_WAT_m=st.executeQuery("SELECT sum(sissue_amt) as cons_tot FROM et_store_issue as ssi WHERE cate_id='cate_1' AND ssi.sissue_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");
         if(rs_WAT_m.next()){ WAT_amt=rs_WAT_m.getDouble("cons_tot");}        
         if(WAT_amt>=DIS_min)
              {
                  String query_WAT1 ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_WAT1);  
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,WAT_amt);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Water Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// contrp
               }
            }//monthly if                                                                                                                                   
//-------------------------------------Revenue(Monthly)-----------------------------------
   if(dateNow.equals(monthfirstdt)){
           double revenu_amt=0.0,total_revenu=0.0,issue_amt=0.0,earning_amt=0.0,tat_exp,total_otherexpence_m=0,total_empexpence_m=0;
            int rev_count=0;
            String rev_mode="";
            ResultSet rs_revenu=st.executeQuery("SELECT arv_minamt, arv_avgamt, arv_revemode FROM et_alert_revenue WHERE arv_revemode='Monthly'");
            if(rs_revenu.next()){
            rev_minamt=rs_revenu.getDouble("arv_minamt");
            rev_avgamt=rs_revenu.getDouble("arv_avgamt");
             }
             ResultSet rs_emp_expence=st.executeQuery("SELECT SUM(empex_travelamt) AS trvel,SUM(empex_mealamt) AS meal,SUM(empex_fuelamt) AS fuel,SUM(empex_hotelamt) AS hotel,SUM(empex_phoneamt) AS phone,SUM(empex_otheramt) AS other FROM et_emp_expanditure WHERE empex_date='"+lastdaydt+"'");
              if(rs_emp_expence.next()){ emp_travel=rs_emp_expence.getDouble("trvel");
                                         emp_meal=rs_emp_expence.getDouble("meal");   
                                         emp_fual=rs_emp_expence.getDouble("fuel"); 
                                         emp_hotel=rs_emp_expence.getDouble("hotel"); 
                                         emp_phone=rs_emp_expence.getDouble("phone");
                                         emp_other=rs_emp_expence.getDouble("other");  
                                             }
         total_empexpence_m=emp_travel+emp_meal+emp_fual+emp_hotel+emp_phone+emp_other;
            
          ResultSet rs_other_expence=st.executeQuery("SELECT sum(othex_amt) AS other FROM et_other_expense where othex_created BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'");
         if(rs_other_expence.next()){ total_otherexpence_m=rs_other_expence.getDouble("other"); }
          ResultSet rs_status_rev=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Revenue detail'");
          while(rs_status_rev.next()){ rev_count++;}
          if(rev_count==1){
          ResultSet rs_rev=st.executeQuery("SELECT sum(sissue_amt) AS st_amt FROM et_store_issue WHERE sissue_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");   
          while(rs_rev.next()){ issue_amt=rs_rev.getDouble("st_amt");}
          ResultSet rs_earning=st.executeQuery("select sum(pphis_paid_amt) as tearn from et_party_payhistory  WHERE pphis_paiddate BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");   
          while(rs_earning.next()){ earning_amt=rs_earning.getDouble("tearn");}           
           tat_exp=total_empexpence_m+total_otherexpence_m+issue_amt;
           total_revenu=tat_exp-earning_amt;  
            
           if(total_revenu<=rev_avgamt)
              {
                  String query_rev ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_rev);   
                  pstmt.setString(1, role_id); 
                  pstmt.setDouble(2,total_revenu);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Revenue detail");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }         
          
              }          
           }//if month first dt
            
  //------------------------------------------------ Revenue Quaterly ----------------------------------- 
//Q1-------------------------
      double arv_daily_q=0,total_otherexpence_q1=0,total_revenu_q1=0,tat_exp_q1=0,earning_amt_q1=0;
      double  total_empexpence_q1=0,emp_travel_q1=0,emp_meal_q1=0,emp_fual_q1=0,emp_hotel_q1=0,emp_phone_q1=0,emp_other_q1=0; 
      double issue_amt_q1=0;
      int counter_q=0;
      String arv_revemode_qtr="";
      ResultSet rs_rev_qtr=st.executeQuery("SELECT * FROM  et_alert_revenue where arv_revemode='Quarterly' ");
         if(rs_rev_qtr.next()){          
               arv_revemode_qtr=rs_rev_qtr.getString("arv_revemode");
               arv_minamt_qtr=rs_rev_qtr.getDouble("arv_minamt");
               arv_avgamt_qtr=rs_rev_qtr.getDouble("arv_avgamt");
          }
            
       if(dateNow.equals(Q2_fdate))
       { 
           ResultSet rs_emp_expence_q1=st.executeQuery("SELECT SUM(empex_travelamt) AS trvel,SUM(empex_mealamt) AS meal,SUM(empex_fuelamt) AS fuel,SUM(empex_hotelamt) AS hotel,SUM(empex_phoneamt) AS phone,SUM(empex_otheramt) AS other FROM et_emp_expanditure WHERE empex_date BETWEEN'"+Q1_fdate+"'AND='"+lastdaydt+"'");
           if(rs_emp_expence_q1.next()){ emp_travel_q1=rs_emp_expence_q1.getDouble("trvel"); 
                                         emp_meal_q1=rs_emp_expence_q1.getDouble("meal");    
                                         emp_fual_q1=rs_emp_expence_q1.getDouble("fuel");  
                                         emp_hotel_q1=rs_emp_expence_q1.getDouble("hotel");  
                                         emp_phone_q1=rs_emp_expence_q1.getDouble("phone");  
                                         emp_other_q1=rs_emp_expence_q1.getDouble("other");    
                                       }
          total_empexpence_q1=emp_travel_q1+emp_meal_q1+emp_fual_q1+emp_hotel_q1+emp_phone_q1+emp_other_q1;
                    
         ResultSet rs_other_expence_q1=st.executeQuery("SELECT sum(othex_amt) AS other FROM et_other_expense where othex_created BETWEEN '"+Q1_fdate+"'AND'"+lastdaydt+"'");
         if(rs_other_expence_q1.next()){ total_otherexpence_q1=rs_other_expence_q1.getDouble("other"); }    
         ResultSet rs_status_rev_q1=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='Q1' AND alert_for='First Quarter Revenue'");
         while(rs_status_rev_q1.next()){counter_q++;}
         if(counter_q==0){
         ResultSet rs_rev=st.executeQuery("SELECT sum(sissue_amt) AS st_amt FROM et_store_issue WHERE sissue_date BETWEEN'"+Q1_fdate+"'AND'"+lastdaydt+"'");   
         while(rs_rev.next()){ issue_amt_q1=rs_rev.getDouble("st_amt");} 
         ResultSet rs_earning_q1=st.executeQuery("select sum(pphis_paid_amt) as tearn from et_party_payhistory  WHERE pphis_paiddate BETWEEN'"+Q1_fdate+"'AND'"+lastdaydt+"'");   
         while(rs_earning_q1.next()){ earning_amt_q1=rs_earning_q1.getDouble("tearn");}             
         tat_exp_q1=total_empexpence_q1+total_otherexpence_q1+issue_amt_q1;   
         total_revenu_q1=tat_exp_q1-earning_amt_q1;    
            
         if(total_revenu_q1<=arv_avgamt_qtr)
           {
                  String query_rev_q1 ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_rev_q1);   
                  pstmt.setString(1, role_id); 
                  pstmt.setDouble(2,total_revenu_q1);
                  pstmt.setString(3,"Q1");
                  pstmt.setString(4,"First Quarter Revenue");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
             }     
          }//cont 
       }//q1      
 //Q2----------------------------------------------------
      if(dateNow.equals(Q3_fdate))
       { 
           ResultSet rs_emp_expence_q1=st.executeQuery("SELECT SUM(empex_travelamt) AS trvel,SUM(empex_mealamt) AS meal,SUM(empex_fuelamt) AS fuel,SUM(empex_hotelamt) AS hotel,SUM(empex_phoneamt) AS phone,SUM(empex_otheramt) AS other FROM et_emp_expanditure WHERE empex_date BETWEEN'"+Q2_fdate+"'AND='"+lastdaydt+"'");
           if(rs_emp_expence_q1.next()){ emp_travel_q1=rs_emp_expence_q1.getDouble("trvel"); 
                                         emp_meal_q1=rs_emp_expence_q1.getDouble("meal");    
                                         emp_fual_q1=rs_emp_expence_q1.getDouble("fuel");  
                                         emp_hotel_q1=rs_emp_expence_q1.getDouble("hotel");  
                                         emp_phone_q1=rs_emp_expence_q1.getDouble("phone");  
                                         emp_other_q1=rs_emp_expence_q1.getDouble("other");    
                                       }
          total_empexpence_q1=emp_travel_q1+emp_meal_q1+emp_fual_q1+emp_hotel_q1+emp_phone_q1+emp_other_q1;
                    
         ResultSet rs_other_expence_q1=st.executeQuery("SELECT sum(othex_amt) AS other FROM et_other_expense where othex_created BETWEEN '"+Q2_fdate+"'AND'"+lastdaydt+"'");
         if(rs_other_expence_q1.next()){ total_otherexpence_q1=rs_other_expence_q1.getDouble("other"); }    
         ResultSet rs_status_rev_q1=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='Q2' AND alert_for='Second Quarter Revenue'");
         while(rs_status_rev_q1.next()){counter_q++;}
         if(counter_q==0){
         ResultSet rs_rev=st.executeQuery("SELECT sum(sissue_amt) AS st_amt FROM et_store_issue WHERE sissue_date BETWEEN'"+Q2_fdate+"'AND'"+lastdaydt+"'");   
         while(rs_rev.next()){ issue_amt_q1=rs_rev.getDouble("st_amt");} 
         ResultSet rs_earning_q1=st.executeQuery("select sum(pphis_paid_amt) as tearn from et_party_payhistory  WHERE pphis_paiddate BETWEEN'"+Q2_fdate+"'AND'"+lastdaydt+"'");   
         while(rs_earning_q1.next()){ earning_amt_q1=rs_earning_q1.getDouble("tearn");}             
         tat_exp_q1=total_empexpence_q1+total_otherexpence_q1+issue_amt_q1;   
         total_revenu_q1=tat_exp_q1-earning_amt_q1;    
            
         if(total_revenu_q1<=arv_avgamt_qtr)
           {
                  String query_rev_q1 ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_rev_q1);   
                  pstmt.setString(1, role_id); 
                  pstmt.setDouble(2,total_revenu_q1);
                  pstmt.setString(3,"Q2");
                  pstmt.setString(4,"Second Quarter Revenue");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
             }     
          }//cont 
       }//q1      
      
      
//Q3-------------------------
      if(dateNow.equals(Q4_fdate))
       { 
           ResultSet rs_emp_expence_q1=st.executeQuery("SELECT SUM(empex_travelamt) AS trvel,SUM(empex_mealamt) AS meal,SUM(empex_fuelamt) AS fuel,SUM(empex_hotelamt) AS hotel,SUM(empex_phoneamt) AS phone,SUM(empex_otheramt) AS other FROM et_emp_expanditure WHERE empex_date BETWEEN'"+Q3_fdate+"'AND='"+lastdaydt+"'");
           if(rs_emp_expence_q1.next()){ emp_travel_q1=rs_emp_expence_q1.getDouble("trvel"); 
                                         emp_meal_q1=rs_emp_expence_q1.getDouble("meal");    
                                         emp_fual_q1=rs_emp_expence_q1.getDouble("fuel");  
                                         emp_hotel_q1=rs_emp_expence_q1.getDouble("hotel");  
                                         emp_phone_q1=rs_emp_expence_q1.getDouble("phone");  
                                         emp_other_q1=rs_emp_expence_q1.getDouble("other");    
                                       }
          total_empexpence_q1=emp_travel_q1+emp_meal_q1+emp_fual_q1+emp_hotel_q1+emp_phone_q1+emp_other_q1;
                    
         ResultSet rs_other_expence_q1=st.executeQuery("SELECT sum(othex_amt) AS other FROM et_other_expense where othex_created BETWEEN '"+Q3_fdate+"'AND'"+lastdaydt+"'");
         if(rs_other_expence_q1.next()){ total_otherexpence_q1=rs_other_expence_q1.getDouble("other"); }    
         ResultSet rs_status_rev_q1=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='Q3' AND alert_for='Third Quarter Revenue'");
         while(rs_status_rev_q1.next()){counter_q++;}
         if(counter_q==0){
         ResultSet rs_rev=st.executeQuery("SELECT sum(sissue_amt) AS st_amt FROM et_store_issue WHERE sissue_date BETWEEN'"+Q3_fdate+"'AND'"+lastdaydt+"'");   
         while(rs_rev.next()){ issue_amt_q1=rs_rev.getDouble("st_amt");} 
         ResultSet rs_earning_q1=st.executeQuery("select sum(pphis_paid_amt) as tearn from et_party_payhistory  WHERE pphis_paiddate BETWEEN'"+Q3_fdate+"'AND'"+lastdaydt+"'");   
         while(rs_earning_q1.next()){ earning_amt_q1=rs_earning_q1.getDouble("tearn");}             
         tat_exp_q1=total_empexpence_q1+total_otherexpence_q1+issue_amt_q1;   
         total_revenu_q1=tat_exp_q1-earning_amt_q1;    
            
         if(total_revenu_q1<=arv_avgamt_qtr)
           {
                  String query_rev_q1 ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_rev_q1);   
                  pstmt.setString(1, role_id); 
                  pstmt.setDouble(2,total_revenu_q1);
                  pstmt.setString(3,"Q3");
                  pstmt.setString(4,"Third Quarter Revenue");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
             }     
          }//cont 
       }//q1      
      
      
      
//Q4-------------------------
            if(dateNow.equals(Q1_fdate))
          { 
           String[] ql=last_yrfdt.split("-");
           Q4_fdate=ql[0]+"-"+"10"+"-"+"01";  
           ResultSet rs_emp_expence_q1=st.executeQuery("SELECT SUM(empex_travelamt) AS trvel,SUM(empex_mealamt) AS meal,SUM(empex_fuelamt) AS fuel,SUM(empex_hotelamt) AS hotel,SUM(empex_phoneamt) AS phone,SUM(empex_otheramt) AS other FROM et_emp_expanditure WHERE empex_date BETWEEN'"+Q4_fdate+"'AND='"+lastdaydt+"'"); 
           if(rs_emp_expence_q1.next()){ emp_travel_q1=rs_emp_expence_q1.getDouble("trvel"); 
                                         emp_meal_q1=rs_emp_expence_q1.getDouble("meal");    
                                         emp_fual_q1=rs_emp_expence_q1.getDouble("fuel");  
                                         emp_hotel_q1=rs_emp_expence_q1.getDouble("hotel");  
                                         emp_phone_q1=rs_emp_expence_q1.getDouble("phone");  
                                         emp_other_q1=rs_emp_expence_q1.getDouble("other");    
                                       }
          total_empexpence_q1=emp_travel_q1+emp_meal_q1+emp_fual_q1+emp_hotel_q1+emp_phone_q1+emp_other_q1;
                    
         ResultSet rs_other_expence_q1=st.executeQuery("SELECT sum(othex_amt) AS other FROM et_other_expense where othex_created BETWEEN '"+Q4_fdate+"'AND'"+lastdaydt+"'");
         if(rs_other_expence_q1.next()){ total_otherexpence_q1=rs_other_expence_q1.getDouble("other"); }    
         ResultSet rs_status_rev_q1=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='Q4' AND alert_for='Fourth Quarter Revenue'");
         while(rs_status_rev_q1.next()){counter_q++;}
         if(counter_q==0){
         ResultSet rs_rev=st.executeQuery("SELECT sum(sissue_amt) AS st_amt FROM et_store_issue WHERE sissue_date BETWEEN'"+Q4_fdate+"'AND'"+lastdaydt+"'");   
         while(rs_rev.next()){ issue_amt_q1=rs_rev.getDouble("st_amt");} 
         ResultSet rs_earning_q1=st.executeQuery("select sum(pphis_paid_amt) as tearn from et_party_payhistory  WHERE pphis_paiddate BETWEEN'"+Q4_fdate+"'AND'"+lastdaydt+"'");   
         while(rs_earning_q1.next()){ earning_amt_q1=rs_earning_q1.getDouble("tearn");}             
         tat_exp_q1=total_empexpence_q1+total_otherexpence_q1+issue_amt_q1;   
         total_revenu_q1=tat_exp_q1-earning_amt_q1;    
            
         if(total_revenu_q1<=arv_avgamt_qtr)
           {
                  String query_rev_q1 ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_rev_q1);   
                  pstmt.setString(1, role_id); 
                  pstmt.setDouble(2,total_revenu_q1);
                  pstmt.setString(3,"Q4");
                  pstmt.setString(4,"Fouth Quarter Revenue");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
             }     
          }//cont 
       }//q1      
            


                                                       
            
  //---------------------------------------------- Revenue( Yearly)------------------------------------ 
if(dateNow.equals(cur_yrfdt)){
           double revenu_amt_y=0.0,total_revenu_y=0.0,issue_amt_y=0.0,earning_amt_y=0.0,tat_exp,total_otherexpence_m_y=0,total_empexpence_m_y=0;
            double emp_travel_y=0,emp_meal_y=0,emp_fual_y=0,emp_hotel_y=0,emp_phone_y=0,emp_other_y=0,tat_exp_y=0; 
           int rev_count_y=0;
            double rev_minamt_y=0,rev_avgamt_y=0;
            String rev_mode_y="";
            ResultSet rs_revenu_y=st.executeQuery("SELECT arv_minamt, arv_avgamt, arv_revemode FROM et_alert_revenue WHERE arv_revemode='Monthly'");
            if(rs_revenu_y.next()){
            rev_minamt_y=rs_revenu_y.getDouble("arv_minamt"); 
            rev_avgamt_y=rs_revenu_y.getDouble("arv_avgamt"); 
             }
             ResultSet rs_emp_expence_y=st.executeQuery("SELECT SUM(empex_travelamt) AS trvel,SUM(empex_mealamt) AS meal,SUM(empex_fuelamt) AS fuel,SUM(empex_hotelamt) AS hotel,SUM(empex_phoneamt) AS phone,SUM(empex_otheramt) AS other FROM et_emp_expanditure WHERE empex_date BETWEEN'"+last_yrfdt+"'AND='"+cur_yrfdt+"'");
              if(rs_emp_expence_y.next()){ emp_travel_y=rs_emp_expence_y.getDouble("trvel");
                                         emp_meal_y=rs_emp_expence_y.getDouble("meal");   
                                         emp_fual_y=rs_emp_expence_y.getDouble("fuel"); 
                                         emp_hotel_y=rs_emp_expence_y.getDouble("hotel"); 
                                         emp_phone_y=rs_emp_expence_y.getDouble("phone"); 
                                         emp_other_y=rs_emp_expence_y.getDouble("other");   
                                             }
         total_empexpence_m_y=emp_travel_y+emp_meal_y+emp_fual_y+emp_hotel_y+emp_phone_y+emp_other_y;  
            
          ResultSet rs_other_expence_y=st.executeQuery("SELECT sum(othex_amt) AS other FROM et_other_expense where othex_created BETWEEN'"+last_yrfdt+"'AND='"+cur_yrfdt+"'");
         if(rs_other_expence_y.next()){ total_otherexpence_m_y=rs_other_expence_y.getDouble("other"); }
          ResultSet rs_status_rev_y=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='Y' AND alert_for='Revenue detail'");
          while(rs_status_rev_y.next()){ rev_count_y++;}
          if(rev_count_y==1){
          ResultSet rs_rev_y=st.executeQuery("SELECT sum(sissue_amt) AS st_amt FROM et_store_issue WHERE sissue_date BETWEEN'"+last_yrfdt+"'AND='"+cur_yrfdt+"'");
          while(rs_rev_y.next()){ issue_amt_y=rs_rev_y.getDouble("st_amt");}
          ResultSet rs_earning_y=st.executeQuery("select sum(pphis_paid_amt) as tearn from et_party_payhistory  WHERE pphis_paiddate BETWEEN'"+last_yrfdt+"'AND='"+cur_yrfdt+"'");
          while(rs_earning_y.next()){ earning_amt_y=rs_earning_y.getDouble("tearn");}           
           tat_exp_y=total_empexpence_m_y+total_otherexpence_m_y+issue_amt_y;
           total_revenu_y=tat_exp_y-earning_amt_y;   
            
           if(total_revenu_y<=rev_avgamt_y)
              {
                  String query_rev_y ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_rev_y);    
                  pstmt.setString(1, role_id); 
                  pstmt.setDouble(2,total_revenu_y);
                  pstmt.setString(3,"Y");
                  pstmt.setString(4,"Revenue detail");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }         
          
              }          
           }//if year                      
          
 //------------------------------------------------------- Bsr(Meter)------------------------------------------
           double pro_totmeter_b=0.0,despatch_totmeter=0.0;
           double total_bsr=0.0;        
           int cont_bsr=0,cont_bsrm=0;          
           int bsr_indaily=0, bsr_inmonthly=0, bsr_indate=0; 
           String bsr_indays="";
           ResultSet rs_rpavgmin_bsr=st.executeQuery("SELECT absr_minval, absr_avgval, absr_indaily, absr_indays, absr_inmonthly, absr_indates FROM et_alert_bsrstock WHERE absr_mode='Meter'");
            if(rs_rpavgmin_bsr.next()){
            bsr_minamt=rs_rpavgmin_bsr.getDouble("absr_minval");
            bsr_avgamt=rs_rpavgmin_bsr.getDouble("absr_avgval");
            bsr_indaily=rs_rpavgmin_bsr.getInt("absr_indaily");            
            bsr_indays=rs_rpavgmin_bsr.getString("absr_indays");
            bsr_inmonthly=rs_rpavgmin_bsr.getInt("absr_inmonthly");            
            bsr_indate=rs_rpavgmin_bsr.getInt("absr_indates");
           }                         
                 
 if(bsr_indaily==1){        
         ResultSet rs_status_bsr=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='BSR meter'");
         while(rs_status_bsr.next()){ cont_bsr++;}
         if(cont_bsr==0){ 
             ResultSet rs_production_b=st.executeQuery("SELECT SUM(finished_meter) as total_finishmeter FROM et_finshing_material WHERE grey_finished_date='"+lastdaydt+"'");
            if(rs_production_b.next()){pro_totmeter_b=rs_production_b.getDouble("total_finishmeter");}
   
            ResultSet rs_despatch=st.executeQuery("SELECT SUM(finished_meter) as finimeter FROM et_despatched_detail AS A, et_packing_slip AS B, et_finshing_material AS C WHERE C.finishing_id = B.finishing_id AND A.bale_no = B.bale_no AND despatch_date='"+dateNow+"'");
          if(rs_despatch.next()){despatch_totmeter=rs_despatch.getDouble("finimeter"); }  total_bsr=pro_totmeter_b-despatch_totmeter;                              
         if(total_bsr<=bsr_avgamt)
                 {  
                 String query_bsr = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_bsr); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_bsr);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"BSR meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();     
                    }   
              } //cnt          
         }//daily           
                       
          
else if(bsr_inmonthly==1){ 
    if(dateNow.equals(monthfirstdt)){        
         ResultSet rs_status_bsr1=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='BSR meter'");
         while(rs_status_bsr1.next()){ cont_bsrm++;}
         if(cont_bsrm==0){ResultSet rs_production_bs=st.executeQuery("SELECT SUM(finished_meter) as total_finishmeter FROM et_finshing_material WHERE grey_finished_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");
    if(rs_production_bs.next()){pro_totmeter_b=rs_production_bs.getDouble("total_finishmeter");}
            
     ResultSet rs_despatch_b=st.executeQuery("SELECT SUM(finished_meter) as finimeter FROM et_despatched_detail AS A, et_packing_slip AS B, et_finshing_material AS C WHERE C.finishing_id = B.finishing_id AND A.bale_no = B.bale_no AND despatch_date BETWEEN'"+monthfirstdt+"'AND'"+dateNow+"'");
             if(rs_despatch_b.next()){despatch_totmeter=rs_despatch_b.getDouble("finimeter");}  
                total_bsr=pro_totmeter_b-despatch_totmeter; 
                if(total_bsr<=bsr_avgamt)
                 {  
                  String query_br = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_br); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_bsr);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"BSR meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                 }  
               }
                 }
            }//monthly    
 //------------------------------------------------------- Bsr(bale)------------------------------------------         
           
         
     double pro_totbale_b=0.0,despatch_totbale=0.0;
           double total_bsr_bale=0.0;        
           int cont_bale=0,cont_balem=0;          
           int bale_indaily=0, bale_inmonthly=0, bale_indate=0; 
           String bale_indays="";
           ResultSet rs_rpavgmin_bale=st.executeQuery("SELECT absr_minval, absr_avgval, absr_indaily, absr_indays, absr_inmonthly, absr_indates FROM et_alert_bsrstock WHERE absr_mode='Bale'");
            if(rs_rpavgmin_bale.next()){
            bale_minamt=rs_rpavgmin_bale.getDouble("absr_minval");
            bale_avgamt=rs_rpavgmin_bale.getDouble("absr_avgval");
            bale_indaily=rs_rpavgmin_bale.getInt("absr_indaily");            
            bale_indays=rs_rpavgmin_bale.getString("absr_indays");
            bale_inmonthly=rs_rpavgmin_bale.getInt("absr_inmonthly");            
            bale_indate=rs_rpavgmin_bale.getInt("absr_indates");
           }                 

if(bale_indaily==1){        
         ResultSet rs_status_bale=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='BSR bale'");
         while(rs_status_bale.next()){ cont_bale++;}
         if(cont_bale==0){ 
             
              ResultSet rs_despatch_bale=st.executeQuery("SELECT COUNT(bale_no) as bale FROM  et_packing_slip  WHERE bale_no NOT IN (SELECT bale_no FROM et_despatched_detail) AND pack_createddate='"+lastdaydt+"'");
          if(rs_despatch_bale.next()){total_bsr_bale=rs_despatch_bale.getDouble("bale"); }
              
               if(total_bsr_bale<=bale_avgamt)
                 {  
                 String query_bsr = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_bsr); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_bsr_bale);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"BSR bale");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();     
                }   
              } //cnt          
         }//daily           
        
         else if(bale_inmonthly==1){ 
    if(dateNow.equals(monthfirstdt)){        
         ResultSet rs_status_bale1=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='BSR bale'");
         while(rs_status_bale1.next()){ cont_balem++;}
         if(cont_balem==0){  ResultSet rs_despatch_bale_m=st.executeQuery("SELECT COUNT(bale_no) as bale FROM  et_packing_slip  WHERE bale_no NOT IN (SELECT bale_no FROM et_despatched_detail)and pack_createddate BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");
          if(rs_despatch_bale_m.next()){total_bsr_bale=rs_despatch_bale_m.getDouble("bale"); }
             if(total_bsr_bale<=bale_avgamt)
                 {  
                  String query_bl = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_bl); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_bsr_bale);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"BSR bale");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                 }  
               }
                 }
            }//monthly                                            

//------------------------------------- Party-Broker danger Zone----------------------------
        ArrayList payamt_arr=new ArrayList();      
        ArrayList falert_arr=new ArrayList();
        String tp="",party_na="",brk_frst="";
       
        ResultSet rs_party_br_d=st.executeQuery("SELECT Party_name ,pphis_pending_amt,broker_prefix,broker_firstname,broker_lastname  FROM et_broker_detail as br,et_party_payhistory as pay, et_party_detail as prty  WHERE prty.party_id=pay.party_id AND prty.broker_id=br.broker_id AND pphis_status='DN'");
        while(rs_party_br_d.next()) {   
                  party_na=rs_party_br_d.getString("Party_name"); 
                  brk_frst=rs_party_br_d.getString("broker_prefix")+rs_party_br_d.getString("broker_firstname")+rs_party_br_d.getString("broker_lastname");
                  tp="Danger"+"-"+party_na+"-"+brk_frst;
                  falert_arr.add(tp);
                  payamt_arr.add(rs_party_br_d.getDouble("pphis_pending_amt"));
                                    }//while  
       for(int k=0;k<falert_arr.size();k++){  int cont_paym=0;
                  ResultSet rs_st_ppm=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='"+falert_arr.get(k)+"'");
                  while(rs_st_ppm.next()){ cont_paym++;} 
                  if(cont_paym==0){
                  String query_bl = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_bl);   
                  pstmt.setString(1, role_id); 
                  pstmt.setString(2,payamt_arr.get(k).toString());
                  pstmt.setString(3,"D");
                  pstmt.setString(4,falert_arr.get(k).toString());
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                }//if cont
               }//party id array              
 //-----------------------------------------------?Over due zone Party and broker-------------------------------------------------------------
        ArrayList payamt_arr_od=new ArrayList();      
        ArrayList falert_arr_od=new ArrayList();
        String tp_od="",party_na_od="",brk_frst_od="";
       
        ResultSet rs_party_br_od=st.executeQuery("SELECT Party_name ,pphis_pending_amt,broker_prefix,broker_firstname,broker_lastname  FROM et_broker_detail as br,et_party_payhistory as pay, et_party_detail as prty  WHERE prty.party_id=pay.party_id AND prty.broker_id=br.broker_id AND pphis_status='OD'");
        while(rs_party_br_od.next()) {   
                  party_na_od=rs_party_br_od.getString("Party_name"); 
                  brk_frst_od=rs_party_br_od.getString("broker_prefix")+rs_party_br_od.getString("broker_firstname")+rs_party_br_od.getString("broker_lastname");
                  tp_od="Over due"+"-"+party_na_od+"-"+brk_frst_od;
                  falert_arr_od.add(tp_od);
                  payamt_arr_od.add(rs_party_br_od.getDouble("pphis_pending_amt"));
                                    }//while  
       for(int j=0;j<falert_arr_od.size();j++){  int cont_paym_od=0;
                  ResultSet rs_st_ppm_od=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='"+falert_arr_od.get(j)+"'");
                  while(rs_st_ppm_od.next()){ cont_paym_od++;} 
                  if(cont_paym_od==0){
                  String query_b_od = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_b_od);   
                  pstmt.setString(1, role_id); 
                  pstmt.setString(2,payamt_arr_od.get(j).toString());
                  pstmt.setString(3,"D");
                  pstmt.setString(4,falert_arr_od.get(j).toString());
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                }//if cont
               }//party id array              
                 
//---------------------------------------------- Machine wise Production ---------------------------------------
         int counter=0; 
         double tot_issue=0.0,tot_fin=0.0,issue_meter=0.0,fin_meter=0.0,width_meter=0.0,fin_meter_mon_s=0; 
          ArrayList arr_id_lot=new ArrayList (); 
          ArrayList mach_id=new ArrayList (); 
          ArrayList mach_name=new ArrayList (); 
          ArrayList mach_fin_month=new ArrayList ();
          ArrayList mach_fin=new ArrayList ();
          ArrayList mach_width=new ArrayList ();          
          String mach_id_lot="";                    
          String[] split_id_lot; 
          ResultSet rs_ass_mc=st.executeQuery("select machine_id,machine_name from et_machine_detail");
          while(rs_ass_mc.next()){ mach_id.add(rs_ass_mc.getString("machine_id"));
          mach_name.add(rs_ass_mc.getString("machine_name"));}     
          
          for(int i=0; i<mach_id.size();i++)
            { 
            ResultSet rs_rec=st.executeQuery("select machine_id,lot_number from et_assign_process where machine_id='"+mach_id.get(i)+"' ");
            while(rs_rec.next()){  
            if(rs_rec.getString("machine_id")!=mach_id.get(i)){String str="mach_id.get(i)"+"~"+"0";
                      arr_id_lot.add(str);}//if
                  mach_id_lot=rs_rec.getString("machine_id")+"~"+rs_rec.getString("lot_number"); 
                  arr_id_lot.add(mach_id_lot);                            
                   }//wh2 
            }
          for(int i=0; i<mach_id.size();i++){
          for(int j=0; j<arr_id_lot.size();j++)
             {
               split_id_lot=(arr_id_lot.get(j).toString()).split("~"); 
          if(mach_id.get(i).equals(split_id_lot[0])){
                 ResultSet rs_fin=st.executeQuery("select SUM(finished_meter)as temp  from et_finshing_material where lot_number='"+split_id_lot[1]+"'AND grey_finished_date='"+lastdaydt+"'");  
                 while(rs_fin.next()){ fin_meter=(rs_fin.getDouble("temp"));}
                 ResultSet rs_fin_month=st.executeQuery("select SUM(finished_meter)as temp_mon  from et_finshing_material where lot_number='"+split_id_lot[1]+"'AND grey_finished_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");
                 while(rs_fin_month.next()){ fin_meter_mon_s=(rs_fin_month.getDouble("temp_mon"));} 
                 
              }//if
             }
             mach_fin.add(fin_meter);  
             mach_fin_month.add(fin_meter_mon_s); 
          }//for i
         for(int i=0; i<mach_id.size();i++){
              String tpm_name = "", mchin_indays = "";
              double m_avg=0,m_production=0;
              int mchin_indaily=0,mchin_inmonthly=0,mchin_indate=0,cont_mac=0;
             ResultSet rs_amchine=st.executeQuery("SELECT * FROM et_alert_machineprod WHERE machine_id='"+mach_id.get(i)+"'");
             while(rs_amchine.next()){           
              m_avg=rs_amchine.getDouble("amprd_avgmeter"); 
              mchin_indaily=rs_amchine.getInt("amprd_daily");         
              mchin_inmonthly=rs_amchine.getInt("amprd_inmonthly");        
             }
            tpm_name="Machine"+"-"+mach_name.get(i);
        if(mchin_indaily==1){  m_production=Double.parseDouble(mach_fin.get(i).toString());
                if(m_production<m_avg){
                 int me_cont=0;
                  ResultSet rs_m1=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='"+tpm_name+"'");
                  while(rs_m1.next()){ me_cont++;} 
                  if(me_cont==0){
                  String query_mac = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_mac);    
                  pstmt.setString(1, role_id);  
                  pstmt.setDouble(2,m_production);
                  pstmt.setString(3,"D"); 
                  pstmt.setString(4,tpm_name); 
                  pstmt.setString(5,dateNow); 
                  pstmt.setString(6,timeNow); 
                  pstmt.executeUpdate();
                }//if cont
         
            } //daily  
            }//if production
         if(dateNow.equals(monthfirstdt)){   
            if(mchin_inmonthly==1){
                
                 m_production=Double.parseDouble(mach_fin.get(i).toString());
                if(m_production<m_avg){
                 int me_cont=0;
                  ResultSet rs_m1=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='"+tpm_name+"'");
                  while(rs_m1.next()){ me_cont++;} 
                  if(me_cont==0){
                  String query_mac = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_mac);    
                  pstmt.setString(1, role_id);  
                  pstmt.setDouble(2,m_production);
                  pstmt.setString(3,"M"); 
                  pstmt.setString(4,tpm_name); 
                  pstmt.setString(5,dateNow); 
                  pstmt.setString(6,timeNow); 
                  pstmt.executeUpdate();
                }//if cont         
             } //daily  
            }//if production    
           }
            
         }//machine id
 //-----------------------------------------------------------pending party paymeny--------------------------------  
           
             
              double total_pend=0.0,pend_mincost=0.0;     
           int pend_st=0,pend_stl=0;          
           int pend_indaily=0, pend_inmonthly=0, pend_indate=0; 
           String pend_indays="";
           ResultSet rs_rpavgmin_pend=st.executeQuery("SELECT aapp_maxpayment, aapp_indays, aapp_indays, aapp_inmonthly, aapp_indate FROM et_alert_allpending_payment");
            if(rs_rpavgmin_pend.next()){
            pend_mincost=rs_rpavgmin_pend.getDouble("aapp_maxpayment");        
            pend_indays=rs_rpavgmin_pend.getString("aapp_indays");
            pend_inmonthly=rs_rpavgmin_pend.getInt("aapp_inmonthly");            
            pend_indate=rs_rpavgmin_pend.getInt("aapp_indate");
           }      
      
 if(pend_inmonthly==1){ 
        if(dateNow.equals(monthfirstdt)){    
         ResultSet rs_pay=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Pending payment'");
         while(rs_pay.next()){ pend_stl++;}
         if(pend_stl==0){
             ResultSet rs_partyx=st.executeQuery("SELECT SUM(item_amt) AS item FROM et_received_item WHERE item_billdate BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'"); 
            while(rs_partyx.next()){total_pend=rs_partyx.getDouble("item");}  
              
              if(total_pend>=pend_mincost)
                 {  
                 String query_store = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_store); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_pend);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Pending payment");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                 }  
               }
               }
            }//monthly
                     
        
   }//manager if
        
//end Manager-------------------------------------------------------------------------        
//=============================== Account (Start) ================================================================        
 if(role_name.equals("Account")){      
  //------------------------------------- Employee Expense---------------------------------------
           double emp_travel=0.0,emp_meal=0.0,emp_fual=0.0,emp_hotel=0.0,emp_phone=0.0,emp_other=0.0,total_empexpence=0.0;
           int cont_emp=0,cont_empp=0;         
           int emp_indaily=0, emp_inmonthly=0, emp_indate=0;  
           String emp_indays="";
           ResultSet rs_rpavgmin_emp=st.executeQuery("SELECT aeo_minamt, aeo_avgamt, aeo_indaily, aeo_inday, aeo_inmonthly, aeo_indates FROM et_alert_empoth WHERE aeo_mode='Employee'");
          if(rs_rpavgmin_emp.next()){
          emp_minamt=rs_rpavgmin_emp.getDouble("aeo_minamt");
          emp_avgmeter=rs_rpavgmin_emp.getDouble("aeo_avgamt");
          emp_indaily=rs_rpavgmin_emp.getInt("aeo_indaily");            
          emp_indays=rs_rpavgmin_emp.getString("aeo_inday");
          emp_inmonthly=rs_rpavgmin_emp.getInt("aeo_inmonthly");            
          emp_indate=rs_rpavgmin_emp.getInt("aeo_indates");
           }                  
 
        if(emp_indaily==1){        
        ResultSet rs_status=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Employee expence amount'");
        while(rs_status.next()){ cont_emp++;}
        if(cont_emp==0){ 
              ResultSet rs_emp_expence=st.executeQuery("SELECT SUM(empex_travelamt) AS trvel,SUM(empex_mealamt) AS meal,SUM(empex_fuelamt) AS fuel,SUM(empex_hotelamt) AS hotel,SUM(empex_phoneamt) AS phone,SUM(empex_otheramt) AS other FROM et_emp_expanditure WHERE empex_date='"+lastdaydt+"'");
              if(rs_emp_expence.next()){ emp_travel=rs_emp_expence.getDouble("trvel");
                                         emp_meal=rs_emp_expence.getDouble("meal");   
                                         emp_fual=rs_emp_expence.getDouble("fuel"); 
                                         emp_hotel=rs_emp_expence.getDouble("hotel"); 
                                         emp_phone=rs_emp_expence.getDouble("phone");
                                         emp_other=rs_emp_expence.getDouble("other");  
                                             }
                                total_empexpence=emp_travel+emp_meal+emp_fual+emp_hotel+emp_phone+emp_other;
              if(total_empexpence>=emp_avgmeter)
                 {  
                  String query_emp = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_emp); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_empexpence);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Employee expence amount");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();     
                    }   
              } //cnt      
           }//daily          
    
   else if(emp_inmonthly==1){  
        ResultSet rs_status_m=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Employee expence amount'");
        while(rs_status_m.next()){ cont_empp++;}
        if(cont_empp==0){
         if(dateNow.equals(monthfirstdt)){
        ResultSet rs_emp_expence=st.executeQuery("SELECT SUM(empex_travelamt) AS trvel,SUM(empex_mealamt) AS meal,SUM(empex_fuelamt) AS fuel,SUM(empex_hotelamt) AS hotel,SUM(empex_phoneamt) AS phone,SUM(empex_otheramt) AS other FROM et_emp_expanditure WHERE empex_date BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'");
        if(rs_emp_expence.next()){ emp_travel=rs_emp_expence.getDouble("trvel");
                                         emp_meal=rs_emp_expence.getDouble("meal");   
                                         emp_fual=rs_emp_expence.getDouble("fuel"); 
                                         emp_hotel=rs_emp_expence.getDouble("hotel"); 
                                         emp_phone=rs_emp_expence.getDouble("phone");
                                       emp_other=rs_emp_expence.getDouble("other");  
                                   }
              total_empexpence=emp_travel+emp_meal+emp_fual+emp_hotel+emp_phone+emp_other;
              if(total_empexpence>=emp_avgmeter)
                 {  
                  String query1 = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query1); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_empexpence);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Employee expence amount");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate(); 
                 }  
               }
              }
            }//monthly  
//--------------------------------------------------- Other Expense ----------------------------------------
            double total_otherexpence=0.0;
            int cont_other=0,cont_otherr=0;          
            int other_indaily=0, other_inmonthly=0, other_indate=0; 
            String other_indays="";
            ResultSet rs_rpavgmin_ot=st.executeQuery("SELECT aeo_minamt, aeo_avgamt, aeo_indaily, aeo_inday, aeo_inmonthly, aeo_indates FROM et_alert_empoth WHERE aeo_mode='Other'");
            if(rs_rpavgmin_ot.next()){
            other_minamt=rs_rpavgmin_ot.getDouble("aeo_minamt");
            other_avgamt=rs_rpavgmin_ot.getDouble("aeo_avgamt");
            other_indaily=rs_rpavgmin_ot.getInt("aeo_indaily");            
            other_indays=rs_rpavgmin_ot.getString("aeo_inday");
            other_inmonthly=rs_rpavgmin_ot.getInt("aeo_inmonthly");            
            other_indate=rs_rpavgmin_ot.getInt("aeo_indates");
         }                         
            
 
 
 if(other_indaily==1){        
         ResultSet rs_status=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Other expence amount'");
         while(rs_status.next()){ cont_other++;}
         if(cont_other==0){ 
         ResultSet rs_other_expence=st.executeQuery("SELECT sum(othex_amt) AS other FROM et_other_expense where othex_created='"+lastdaydt+"'");
         if(rs_other_expence.next()){total_otherexpence=rs_other_expence.getDouble("other");}                                
         if(total_otherexpence>=other_avgamt)
                 {  
                 String query = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_empexpence);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Other expence amount");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();     
                    }   
              } //cnt          
         }//daily          
    
   else if(other_inmonthly==1){ 
   if(dateNow.equals(monthfirstdt)){       
         ResultSet rs_status_m=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Other expence amount'");
         while(rs_status_m.next()){ cont_otherr++;}
         if(cont_otherr==0){
              ResultSet rs_other_expence=st.executeQuery("SELECT sum(othex_amt) AS other FROM et_other_expense where othex_created BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'");
              if(rs_other_expence.next()){ total_otherexpence=rs_other_expence.getDouble("other"); }
              if(total_empexpence>=other_avgamt )
                 {  
                  String query1 = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query1); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_otherexpence);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Other expence amount");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate(); 
                 }  
               }
                 }
            }//monthly
 //-------------------------------------Revenue(Monthly)-----------------------------------
   if(dateNow.equals(monthfirstdt)){
           double revenu_amt=0.0,total_revenu=0.0,issue_amt=0.0,earning_amt=0.0,tat_exp,total_otherexpence_m=0,total_empexpence_m=0;
            int rev_count=0;
            String rev_mode="";
            ResultSet rs_revenu=st.executeQuery("SELECT arv_minamt, arv_avgamt, arv_revemode FROM et_alert_revenue WHERE arv_revemode='Monthly'");
            if(rs_revenu.next()){
            rev_minamt=rs_revenu.getDouble("arv_minamt");
            rev_avgamt=rs_revenu.getDouble("arv_avgamt");
             }
             ResultSet rs_emp_expence=st.executeQuery("SELECT SUM(empex_travelamt) AS trvel,SUM(empex_mealamt) AS meal,SUM(empex_fuelamt) AS fuel,SUM(empex_hotelamt) AS hotel,SUM(empex_phoneamt) AS phone,SUM(empex_otheramt) AS other FROM et_emp_expanditure WHERE empex_date='"+lastdaydt+"'");
              if(rs_emp_expence.next()){ emp_travel=rs_emp_expence.getDouble("trvel");
                                         emp_meal=rs_emp_expence.getDouble("meal");   
                                         emp_fual=rs_emp_expence.getDouble("fuel"); 
                                         emp_hotel=rs_emp_expence.getDouble("hotel"); 
                                         emp_phone=rs_emp_expence.getDouble("phone");
                                         emp_other=rs_emp_expence.getDouble("other");  
                                             }
         total_empexpence_m=emp_travel+emp_meal+emp_fual+emp_hotel+emp_phone+emp_other;
            
          ResultSet rs_other_expence=st.executeQuery("SELECT sum(othex_amt) AS other FROM et_other_expense where othex_created BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'");
         if(rs_other_expence.next()){ total_otherexpence_m=rs_other_expence.getDouble("other"); }
          ResultSet rs_status_rev=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Revenue detail'");
          while(rs_status_rev.next()){ rev_count++;}
          if(rev_count==1){
          ResultSet rs_rev=st.executeQuery("SELECT sum(sissue_amt) AS st_amt FROM et_store_issue WHERE sissue_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");   
          while(rs_rev.next()){ issue_amt=rs_rev.getDouble("st_amt");}
          ResultSet rs_earning=st.executeQuery("select sum(pphis_paid_amt) as tearn from et_party_payhistory  WHERE pphis_paiddate BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");   
          while(rs_earning.next()){ earning_amt=rs_earning.getDouble("tearn");}           
           tat_exp=total_empexpence_m+total_otherexpence_m+issue_amt;
           total_revenu=tat_exp-earning_amt;  
            
           if(total_revenu<=rev_avgamt)
              {
                  String query_rev ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_rev);   
                  pstmt.setString(1, role_id); 
                  pstmt.setDouble(2,total_revenu);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Revenue detail");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }         
          
              }          
           }//if month first dt                    
     //-----------------------------store expence------------------------------------------------
              
           double total_st_amt=0.0;        
           int cont_st=0,cont_stl=0;          
           int st_indaily=0, st_inmonthly=0, st_indate=0; 
           String st_indays="";
           ResultSet rs_rpavgmin_st=st.executeQuery("SELECT aeo_minamt, aeo_avgamt, aeo_indaily, aeo_inday, aeo_inmonthly, aeo_indates FROM et_alert_empoth WHERE aeo_mode='Store'");
            if(rs_rpavgmin_st.next()){
            st_mincost=rs_rpavgmin_st.getDouble("aeo_minamt");
            st_avgcost=rs_rpavgmin_st.getDouble("aeo_avgamt");
            st_indaily=rs_rpavgmin_st.getInt("aeo_indaily");            
            st_indays=rs_rpavgmin_st.getString("aeo_inday");
            st_inmonthly=rs_rpavgmin_st.getInt("aeo_inmonthly");            
            st_indate=rs_rpavgmin_st.getInt("aeo_indates");
           }   
    if(st_indaily==1){                  
            ResultSet rs_status_exp=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Store expence'");
            while(rs_status_exp.next()){ cont_st++;}
            if(cont_st==0){               
            ResultSet rs_store_expence=st.executeQuery("SELECT SUM(item_amt) AS item FROM et_received_item WHERE item_billdate='"+lastdaydt+"'"); 
            while(rs_store_expence.next()){total_st_amt=rs_store_expence.getDouble("item");}  
             if(total_st_amt>=st_avgcost)
                 {  
                 String query_store = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_store); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_st_amt);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Store expence");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                 }  
              }                       
              }
                  
    else if(st_inmonthly==1){ 
    if(dateNow.equals(monthfirstdt)){        
         ResultSet rs_status_st=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Store expence'");
         while(rs_status_st.next()){ cont_stl++;}
         if(cont_stl==0){
             ResultSet rs_store_stex=st.executeQuery("SELECT SUM(item_amt) AS item FROM et_received_item WHERE item_billdate=BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'"); 
            while(rs_store_stex.next()){total_st_amt=rs_store_stex.getDouble("item");}  
              
              if(total_st_amt>=st_avgcost)
                 {  
                 String query_store = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_store); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_st_amt);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Store expence");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                 }  
               }
                 }
            }//monthly
 }
//====================================================Folding(Start)==============================================         
if(role_name.equals("Folding")){      
        //--------------------------------------------------Production(folding)-------------------
 if(prd_indaily==1){        
        ResultSet rs_status=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Production stock meter'");
        while(rs_status.next()){ cont_p++;}
        if(cont_p==0){    
    
        ResultSet rs_production_d=st.executeQuery("SELECT SUM(finished_meter) as finished_meter FROM et_finshing_material WHERE finished_status='PCK' AND grey_finished_date='"+lastdaydt+"'");
        if(rs_production_d.next()){
        productionmeter=rs_production_d.getDouble("finished_meter");}
        if(productionmeter<=prg_avgmeter)
               {
                  String query_p ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_p); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,productionmeter);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Production stock meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// contp
           }
        
        else if(prd_inmonthly==1){ 
        if(dateNow.equals(monthfirstdt)){
        ResultSet rs_status_m=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Production stock meter'");
        while(rs_status_m.next()){ cont_pp++;}

        if(cont_pp==0){ 
        ResultSet rs_production_d=st.executeQuery("SELECT SUM(finished_meter) as finished_meter FROM et_finshing_material WHERE grey_finished_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'AND finished_status='PCK'");
        if(rs_production_d.next()){ productionmeter=rs_production_d.getDouble("finished_meter");}
        if(productionmeter<=prg_avgmeter)
                 {
              String query_p ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_p); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,productionmeter);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Production stock meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                  }              
                 }//contpp
             }//if mon first date
            }//monthly if   
 //------------------------------------------------------- Bsr(Meter)------------------------------------------
           double pro_totmeter_b=0.0,despatch_totmeter=0.0;
           double total_bsr=0.0;        
           int cont_bsr=0,cont_bsrm=0;          
           int bsr_indaily=0, bsr_inmonthly=0, bsr_indate=0; 
           String bsr_indays="";
           ResultSet rs_rpavgmin_bsr=st.executeQuery("SELECT absr_minval, absr_avgval, absr_indaily, absr_indays, absr_inmonthly, absr_indates FROM et_alert_bsrstock WHERE absr_mode='Meter'");
            if(rs_rpavgmin_bsr.next()){
            bsr_minamt=rs_rpavgmin_bsr.getDouble("absr_minval");
            bsr_avgamt=rs_rpavgmin_bsr.getDouble("absr_avgval");
            bsr_indaily=rs_rpavgmin_bsr.getInt("absr_indaily");            
            bsr_indays=rs_rpavgmin_bsr.getString("absr_indays");
            bsr_inmonthly=rs_rpavgmin_bsr.getInt("absr_inmonthly");            
            bsr_indate=rs_rpavgmin_bsr.getInt("absr_indates");
           }                         
                 
 if(bsr_indaily==1){        
         ResultSet rs_status_bsr=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='BSR meter'");
         while(rs_status_bsr.next()){ cont_bsr++;}
         if(cont_bsr==0){ 
             ResultSet rs_production_b=st.executeQuery("SELECT SUM(finished_meter) as total_finishmeter FROM et_finshing_material WHERE grey_finished_date='"+lastdaydt+"'");
            if(rs_production_b.next()){pro_totmeter_b=rs_production_b.getDouble("total_finishmeter");}
   
            ResultSet rs_despatch=st.executeQuery("SELECT SUM(finished_meter) as finimeter FROM et_despatched_detail AS A, et_packing_slip AS B, et_finshing_material AS C WHERE C.finishing_id = B.finishing_id AND A.bale_no = B.bale_no AND despatch_date='"+dateNow+"'");
          if(rs_despatch.next()){despatch_totmeter=rs_despatch.getDouble("finimeter"); }  total_bsr=pro_totmeter_b-despatch_totmeter;                              
         if(total_bsr<=bsr_avgamt)
                 {  
                 String query_bsr = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_bsr); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_bsr);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"BSR meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();     
                    }   
              } //cnt          
         }//daily           
                       
          
else if(bsr_inmonthly==1){ 
    if(dateNow.equals(monthfirstdt)){        
         ResultSet rs_status_bsr1=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='BSR meter'");
         while(rs_status_bsr1.next()){ cont_bsrm++;}
         if(cont_bsrm==0){ResultSet rs_production_bs=st.executeQuery("SELECT SUM(finished_meter) as total_finishmeter FROM et_finshing_material WHERE grey_finished_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");
    if(rs_production_bs.next()){pro_totmeter_b=rs_production_bs.getDouble("total_finishmeter");}
            
     ResultSet rs_despatch_b=st.executeQuery("SELECT SUM(finished_meter) as finimeter FROM et_despatched_detail AS A, et_packing_slip AS B, et_finshing_material AS C WHERE C.finishing_id = B.finishing_id AND A.bale_no = B.bale_no AND despatch_date BETWEEN'"+monthfirstdt+"'AND'"+dateNow+"'");
             if(rs_despatch_b.next()){despatch_totmeter=rs_despatch_b.getDouble("finimeter");}  
                total_bsr=pro_totmeter_b-despatch_totmeter; 
                if(total_bsr<=bsr_avgamt)
                 {  
                  String query_br = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_br); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_bsr);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"BSR meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                 }  
               }
                 }
            }//monthly                     
//------------------------------------------------------- Bsr(bale)------------------------------------------         
           
         
     double pro_totbale_b=0.0,despatch_totbale=0.0;
           double total_bsr_bale=0.0;        
           int cont_bale=0,cont_balem=0;          
           int bale_indaily=0, bale_inmonthly=0, bale_indate=0; 
           String bale_indays="";
           ResultSet rs_rpavgmin_bale=st.executeQuery("SELECT absr_minval, absr_avgval, absr_indaily, absr_indays, absr_inmonthly, absr_indates FROM et_alert_bsrstock WHERE absr_mode='Bale'");
            if(rs_rpavgmin_bale.next()){
            bale_minamt=rs_rpavgmin_bale.getDouble("absr_minval");
            bale_avgamt=rs_rpavgmin_bale.getDouble("absr_avgval");
            bale_indaily=rs_rpavgmin_bale.getInt("absr_indaily");            
            bale_indays=rs_rpavgmin_bale.getString("absr_indays");
            bale_inmonthly=rs_rpavgmin_bale.getInt("absr_inmonthly");            
            bale_indate=rs_rpavgmin_bale.getInt("absr_indates");
           }                 

if(bale_indaily==1){        
         ResultSet rs_status_bale=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='BSR bale'");
         while(rs_status_bale.next()){ cont_bale++;}
         if(cont_bale==0){ 
             
              ResultSet rs_despatch_bale=st.executeQuery("SELECT COUNT(bale_no) as bale FROM  et_packing_slip  WHERE bale_no NOT IN (SELECT bale_no FROM et_despatched_detail) AND pack_createddate='"+lastdaydt+"'");
          if(rs_despatch_bale.next()){total_bsr_bale=rs_despatch_bale.getDouble("bale"); }
              
               if(total_bsr_bale<=bale_avgamt)
                 {  
                 String query_bsr = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_bsr); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_bsr_bale);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"BSR bale");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();     
                }   
              } //cnt          
         }//daily           
        
         else if(bale_inmonthly==1){ 
    if(dateNow.equals(monthfirstdt)){        
         ResultSet rs_status_bale1=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='BSR bale'");
         while(rs_status_bale1.next()){ cont_balem++;}
         if(cont_balem==0){  ResultSet rs_despatch_bale_m=st.executeQuery("SELECT COUNT(bale_no) as bale FROM  et_packing_slip  WHERE bale_no NOT IN (SELECT bale_no FROM et_despatched_detail)and pack_createddate BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");
          if(rs_despatch_bale_m.next()){total_bsr_bale=rs_despatch_bale_m.getDouble("bale"); }
             if(total_bsr_bale<=bale_avgamt)
                 {  
                  String query_bl = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_bl); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_bsr_bale);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"BSR bale");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                 }  
               }
                 }
            }//monthly              

//------------------------------------- Party-Broker danger Zone----------------------------
        ArrayList payamt_arr=new ArrayList();      
        ArrayList falert_arr=new ArrayList();
        String tp="",party_na="",brk_frst="";
       
        ResultSet rs_party_br_d=st.executeQuery("SELECT Party_name ,pphis_pending_amt,broker_prefix,broker_firstname,broker_lastname  FROM et_broker_detail as br,et_party_payhistory as pay, et_party_detail as prty  WHERE prty.party_id=pay.party_id AND prty.broker_id=br.broker_id AND pphis_status='DN'");
        while(rs_party_br_d.next()) {   
                  party_na=rs_party_br_d.getString("Party_name"); 
                  brk_frst=rs_party_br_d.getString("broker_prefix")+rs_party_br_d.getString("broker_firstname")+rs_party_br_d.getString("broker_lastname");
                  tp="Danger"+"-"+party_na+"-"+brk_frst;
                  falert_arr.add(tp);
                  payamt_arr.add(rs_party_br_d.getDouble("pphis_pending_amt"));
                                    }//while  
       for(int k=0;k<falert_arr.size();k++){  int cont_paym=0;
                  ResultSet rs_st_ppm=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='"+falert_arr.get(k)+"'");
                  while(rs_st_ppm.next()){ cont_paym++;} 
                  if(cont_paym==0){
                  String query_bl = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_bl);   
                  pstmt.setString(1, role_id); 
                  pstmt.setString(2,payamt_arr.get(k).toString());
                  pstmt.setString(3,"D");
                  pstmt.setString(4,falert_arr.get(k).toString());
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                }//if cont
               }//party id array              
 //-----------------------------------------------?Over due zone Party and broker-------------------------------------------------------------
        ArrayList payamt_arr_od=new ArrayList();      
        ArrayList falert_arr_od=new ArrayList();
        String tp_od="",party_na_od="",brk_frst_od="";
       
        ResultSet rs_party_br_od=st.executeQuery("SELECT Party_name ,pphis_pending_amt,broker_prefix,broker_firstname,broker_lastname  FROM et_broker_detail as br,et_party_payhistory as pay, et_party_detail as prty  WHERE prty.party_id=pay.party_id AND prty.broker_id=br.broker_id AND pphis_status='OD'");
        while(rs_party_br_od.next()) {   
                  party_na_od=rs_party_br_od.getString("Party_name"); 
                  brk_frst_od=rs_party_br_od.getString("broker_prefix")+rs_party_br_od.getString("broker_firstname")+rs_party_br_od.getString("broker_lastname");
                  tp_od="Over due"+"-"+party_na_od+"-"+brk_frst_od;
                  falert_arr_od.add(tp_od);
                  payamt_arr_od.add(rs_party_br_od.getDouble("pphis_pending_amt"));
                                    }//while  
       for(int j=0;j<falert_arr_od.size();j++){  int cont_paym_od=0;
                  ResultSet rs_st_ppm_od=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='"+falert_arr_od.get(j)+"'");
                  while(rs_st_ppm_od.next()){ cont_paym_od++;} 
                  if(cont_paym_od==0){
                  String query_b_od = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_b_od);   
                  pstmt.setString(1, role_id); 
                  pstmt.setString(2,payamt_arr_od.get(j).toString());
                  pstmt.setString(3,"D");
                  pstmt.setString(4,falert_arr_od.get(j).toString());
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                }//if cont
               }//party id array              
    //-------------------------------------- dispatch bale ---------------------------------------
                          
            double dispatch_bale=0;
            int cont_dis=0,cont_dis_m=0,dis_daily=0,dis_monthly=0;
            ResultSet rs_dispa=st.executeQuery("SELECT * FROM et_alert_despatch");
            while(rs_dispa.next()){
                dis_minm=rs_dispa.getDouble("ades_minval");
                dis_avgm=rs_dispa.getDouble("ades_avgval");
                dis_daily=rs_dispa.getInt("ades_indaily");
                dis_monthly=rs_dispa.getInt("ades_inmonthly");
               }
            if(dis_daily==1){
            ResultSet rs_status_dispatch=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Despatch bale'");
            while(rs_status_dispatch.next()){ cont_dis++;}
            if(cont_dis==0){               
             ResultSet rs_dispatch=st.executeQuery("SELECT count(bale_no) AS st_bale FROM et_despatched_detail WHERE despatch_date='"+lastdaydt+"'");   
            while(rs_dispatch.next()){ dispatch_bale=rs_dispatch.getDouble("st_bale");}
            if(dispatch_bale<=dis_avgm){
            String query_dispatch= "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_dispatch); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,dispatch_bale);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Despatch bale");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
              } 
            }       
            }//daily    
          if(dateNow.equals(monthfirstdt)){    
            if(dis_monthly==1){
            ResultSet rs_status_dispatch=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Despatch bale'");
            while(rs_status_dispatch.next()){ cont_dis++;}
            if(cont_dis==0){               
            ResultSet rs_dispatch=st.executeQuery("SELECT count(bale_no) AS st_bale FROM et_despatched_detail WHERE despatch_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");   
            while(rs_dispatch.next()){ dispatch_bale=rs_dispatch.getDouble("st_bale");} 
            if(dispatch_bale<=dis_avgm){
            String query_dispatch= "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_dispatch); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,dispatch_bale);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Despatch bale");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
              }  
             }      
            }//mon    
          } //monthy
                                         
}//============================================== Grey(Start)===========================================================
   if(role_name.equals("Grey")){ 
           if(ags_indaily==1){        
        ResultSet rs_status=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Grey stock meter'");
        while(rs_status.next()){ cont++; }
        if(cont==0){ 
        ResultSet rs_geymeter_d=st.executeQuery("SELECT SUM(pcsdetail_actualmeter) as pcsdetail_actualmeter FROM et_grey_pcsdetail WHERE pcsdetail_status='GB' AND pcsdetail_modified='"+lastdaydt+"'");
        if(rs_geymeter_d.next()){ greybalanced=rs_geymeter_d.getDouble("pcsdetail_actualmeter"); }
        if(greybalanced<=ags_avgmeter)
                 {  
                 String query = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,greybalanced);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Grey stock meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();     
                    }   
              } //cnt          
          }//daily
           else if(!ags_indays.equals("")){}//indays
           if(ags_indate==0){}//Perticular_date
    
           else if(ags_inmonthly==1){
           if(dateNow.equals(monthfirstdt)){
           ResultSet rs_status_m=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Grey stock meter'");
           while(rs_status_m.next()){ cont_m++;}
           if(cont_m==0){
           ResultSet rs_geymeter_dd=st.executeQuery("SELECT SUM(pcsdetail_actualmeter) as pcsdetail_actualmeter FROM et_grey_pcsdetail WHERE pcsdetail_modified BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"' AND pcsdetail_status='GB'");
           if(rs_geymeter_dd.next()){ greybalanced1=rs_geymeter_dd.getDouble("pcsdetail_actualmeter"); }
           if(greybalanced1<=ags_avgmeter )
            {  
                  String query1 = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query1); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,greybalanced1);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Grey stock meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate(); 
             } 
             }  //cont_m     
             }//if of first date
           }//monthly
//--------------------------------------------Grey issue----------------------------------------
        double total_is_meter=0.0;        
           int cont_iss=0,cont_issl=0;          
           int iss_indaily=0, iss_inmonthly=0, iss_indate=0; 
           String iss_indays="";
           ResultSet rs_rpavgmin_iss=st.executeQuery("SELECT agi_minmeter, agi_avgmeter, agi_indaily, agi_indays, agi_inmonthly, agi_indate FROM et_alert_greyissue");
            if(rs_rpavgmin_iss.next()){
            iss_minmeter=rs_rpavgmin_iss.getDouble("agi_minmeter");
            iss_avgamt=rs_rpavgmin_iss.getDouble("agi_avgmeter");
            iss_indaily=rs_rpavgmin_iss.getInt("agi_indaily");            
            iss_indays=rs_rpavgmin_iss.getString("agi_indays");
            iss_inmonthly=rs_rpavgmin_iss.getInt("agi_inmonthly");            
            iss_indate=rs_rpavgmin_iss.getInt("agi_indate");
           }                              
            if(iss_indaily==1){
           ResultSet rs_status_iuuse=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Grey issue'");
            while(rs_status_iuuse.next()){ cont_iss++;}
            if(cont_iss==0){               
            ResultSet rs_issue=st.executeQuery("SELECT sum(sissue_amt) AS st_amt FROM et_store_issue WHERE sissue_date='"+lastdaydt+"'");   
            while(rs_issue.next()){ total_is_meter=rs_issue.getDouble("st_amt");} 
            
             if(total_is_meter>=iss_avgamt){
            String query_issue= "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_issue); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_is_meter);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Grey issue");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                }        
                    }
              }//daily........
           
    else if(iss_inmonthly==1){  
    if(dateNow.equals(monthfirstdt)){        
         ResultSet rs_status_iss=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Coal Consumption'");
         while(rs_status_iss.next()){ cont_issl++;}
         if(cont_issl==0){
             ResultSet rs_issue_m=st.executeQuery("SELECT sum(sissue_amt) AS st_amt FROM et_store_issue WHERE sissue_date=BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'");   
            while(rs_issue_m.next()){ total_is_meter=rs_issue_m.getDouble("st_amt");} 
             
              if(total_is_meter>=iss_avgamt){
            String query_issue= "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_issue); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_is_meter);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Grey issue");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                }     //end of if   
                }
               }
               
            }//monthly                                         
        
            
 }//===================================== Process Start ====================================================================

 if(role_name.equals("Process")){
            double reprocess_meter=0;
            int rp_indaily=0, rp_inmonthly=0, rp_indate=0,cont_rp=0,cont_rpp=0,conp=0; 
            String rp_indays="";
            ResultSet rs_rpavgmin=st.executeQuery("SELECT arp_minmeter, arp_avgmeter, arp_indaily, arp_inday, arp_inmonthly, arp_indates FROM et_alert_reprocess");
            if(rs_rpavgmin.next()){
            rp_minmeter=rs_rpavgmin.getDouble("arp_minmeter");
            rp_avgmeter=rs_rpavgmin.getDouble("arp_avgmeter");
            rp_indaily=rs_rpavgmin.getInt("arp_indaily");            
            rp_indays=rs_rpavgmin.getString("arp_inday");
            rp_inmonthly=rs_rpavgmin.getInt("arp_inmonthly");            
            rp_indate=rs_rpavgmin.getInt("arp_indates");
            }       
      if(rp_indaily==1){         
      ResultSet rs_status_2=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Reprocess Grey stock meter'");
      while(rs_status_2.next()){ cont_rp++;}
      if(cont_rp==0){    
     
        ResultSet rs_reprocess_d=st.executeQuery("SELECT SUM(rp_pcdetail_actualmeter) AS rep_tot FROM et_reprocess_pcsdetail WHERE rp_pcdetail_status='GI' AND rp_pcdetail_modified='"+lastdaydt+"'");
        if(rs_reprocess_d.next()){reprocess_meter=rs_reprocess_d.getDouble("rep_tot");}
        if(reprocess_meter<=rp_avgmeter)
              {
              String query_rp ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_rp);  
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,reprocess_meter);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Reprocess Grey stock meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// contrp
            
           }
       else if(rp_inmonthly==1){ 
if(dateNow.equals(monthfirstdt)){                             
           ResultSet rs_status_m=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date ='"+dateNow+"' AND alert_mode='M' AND alert_for='Reprocess Grey stock meter'");
              while(rs_status_m.next()){ cont_rpp++;}
         if(cont_rpp==0){ 
         ResultSet rs_production_d=st.executeQuery("SELECT SUM(finished_meter) as finished_meter FROM et_finshing_material WHERE grey_finished_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'AND finished_status='PCK'");
         if(rs_production_d.next()){
         productionmeter=rs_production_d.getDouble("finished_meter");}
         if(productionmeter<=rp_avgmeter)
                 {
              String query_p ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_p);  
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,productionmeter);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Reprocess Grey stock meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                  }              
                 }//contpp              
                     }
}//monthly if
 //--------------------------------------------------Production(process)-------------------
if(prd_indaily==1){        
        ResultSet rs_status=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Production stock meter'");
        while(rs_status.next()){ conp++;}
        if(conp==0){     
        ResultSet rs_production_d=st.executeQuery("SELECT SUM(finished_meter) as finished_meter FROM et_finshing_material WHERE finished_status='PCK' AND grey_finished_date='"+lastdaydt+"'");
        if(rs_production_d.next()){productionmeter=rs_production_d.getDouble("finished_meter");}
        if(productionmeter<=prg_avgmeter)
               {
                  String query_p ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_p); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,productionmeter);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Production stock meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// contp
           }
        
        else if(prd_inmonthly==1){ 
        if(dateNow.equals(monthfirstdt)){
        ResultSet rs_status_m=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Production stock meter'");
        while(rs_status_m.next()){ cont_pp++;}

        if(cont_pp==0){ 
        ResultSet rs_production_d=st.executeQuery("SELECT SUM(finished_meter) as finished_meter FROM et_finshing_material WHERE grey_finished_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'AND finished_status='PCK'");
        if(rs_production_d.next()){ productionmeter=rs_production_d.getDouble("finished_meter");}
        if(productionmeter<=prg_avgmeter)
                 {
              String query_p ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_p);  
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,productionmeter);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Production stock meter");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                  }              
                 }//contpp
             }//if mon first date
            }//monthly if      
//------------------------------------- Party-Broker danger Zone----------------------------
        ArrayList payamt_arr=new ArrayList();      
        ArrayList falert_arr=new ArrayList();
        String tp="",party_na="",brk_frst="";
       
        ResultSet rs_party_br_d=st.executeQuery("SELECT Party_name ,pphis_pending_amt,broker_prefix,broker_firstname,broker_lastname  FROM et_broker_detail as br,et_party_payhistory as pay, et_party_detail as prty  WHERE prty.party_id=pay.party_id AND prty.broker_id=br.broker_id AND pphis_status='DN'");
        while(rs_party_br_d.next()) {   
                  party_na=rs_party_br_d.getString("Party_name"); 
                  brk_frst=rs_party_br_d.getString("broker_prefix")+rs_party_br_d.getString("broker_firstname")+rs_party_br_d.getString("broker_lastname");
                  tp="Danger"+"-"+party_na+"-"+brk_frst;
                  falert_arr.add(tp);
                  payamt_arr.add(rs_party_br_d.getDouble("pphis_pending_amt"));
                                    }//while  
       for(int k=0;k<falert_arr.size();k++){  int cont_paym=0;
                  ResultSet rs_st_ppm=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='"+falert_arr.get(k)+"'");
                  while(rs_st_ppm.next()){ cont_paym++;} 
                  if(cont_paym==0){
                  String query_bl = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_bl);   
                  pstmt.setString(1, role_id); 
                  pstmt.setString(2,payamt_arr.get(k).toString());
                  pstmt.setString(3,"D");
                  pstmt.setString(4,falert_arr.get(k).toString());
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                }//if cont
               }//party id array              
 //-----------------------------------------------?Over due zone Party and broker-------------------------------------------------------------
        ArrayList payamt_arr_od=new ArrayList();      
        ArrayList falert_arr_od=new ArrayList();
        String tp_od="",party_na_od="",brk_frst_od="";
       
        ResultSet rs_party_br_od=st.executeQuery("SELECT Party_name ,pphis_pending_amt,broker_prefix,broker_firstname,broker_lastname  FROM et_broker_detail as br,et_party_payhistory as pay, et_party_detail as prty  WHERE prty.party_id=pay.party_id AND prty.broker_id=br.broker_id AND pphis_status='OD'");
        while(rs_party_br_od.next()) {   
                  party_na_od=rs_party_br_od.getString("Party_name"); 
                  brk_frst_od=rs_party_br_od.getString("broker_prefix")+rs_party_br_od.getString("broker_firstname")+rs_party_br_od.getString("broker_lastname");
                  tp_od="Over due"+"-"+party_na_od+"-"+brk_frst_od;
                  falert_arr_od.add(tp_od);
                  payamt_arr_od.add(rs_party_br_od.getDouble("pphis_pending_amt"));
                                    }//while  
       for(int j=0;j<falert_arr_od.size();j++){  int cont_paym_od=0;
                  ResultSet rs_st_ppm_od=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='"+falert_arr_od.get(j)+"'");
                  while(rs_st_ppm_od.next()){ cont_paym_od++;} 
                  if(cont_paym_od==0){
                  String query_b_od = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_b_od);   
                  pstmt.setString(1, role_id); 
                  pstmt.setString(2,payamt_arr_od.get(j).toString());
                  pstmt.setString(3,"D");
                  pstmt.setString(4,falert_arr_od.get(j).toString());
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                }//if cont
               }//party id array              
 //--------------------------------------------Grey issue----------------------------------------
        double total_is_meter=0.0;        
           int cont_iss=0,cont_issl=0;          
           int iss_indaily=0, iss_inmonthly=0, iss_indate=0; 
           String iss_indays="";
           ResultSet rs_rpavgmin_iss=st.executeQuery("SELECT agi_minmeter, agi_avgmeter, agi_indaily, agi_indays, agi_inmonthly, agi_indate FROM et_alert_greyissue");
            if(rs_rpavgmin_iss.next()){
            iss_minmeter=rs_rpavgmin_iss.getDouble("agi_minmeter");
            iss_avgamt=rs_rpavgmin_iss.getDouble("agi_avgmeter");
            iss_indaily=rs_rpavgmin_iss.getInt("agi_indaily");            
            iss_indays=rs_rpavgmin_iss.getString("agi_indays");
            iss_inmonthly=rs_rpavgmin_iss.getInt("agi_inmonthly");            
            iss_indate=rs_rpavgmin_iss.getInt("agi_indate");
           }                              
            if(iss_indaily==1){
           ResultSet rs_status_iuuse=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Grey issue'");
            while(rs_status_iuuse.next()){ cont_iss++;}
            if(cont_iss==0){               
            ResultSet rs_issue=st.executeQuery("SELECT sum(sissue_amt) AS st_amt FROM et_store_issue WHERE sissue_date='"+lastdaydt+"'");   
            while(rs_issue.next()){ total_is_meter=rs_issue.getDouble("st_amt");} 
            
             if(total_is_meter>=iss_avgamt){
            String query_issue= "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_issue); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_is_meter);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Grey issue");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                }        
                    }
              }//daily........
           
    else if(iss_inmonthly==1){  
    if(dateNow.equals(monthfirstdt)){        
         ResultSet rs_status_iss=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Coal Consumption'");
         while(rs_status_iss.next()){ cont_issl++;}
         if(cont_issl==0){
             ResultSet rs_issue_m=st.executeQuery("SELECT sum(sissue_amt) AS st_amt FROM et_store_issue WHERE sissue_date=BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'");   
            while(rs_issue_m.next()){ total_is_meter=rs_issue_m.getDouble("st_amt");} 
             
              if(total_is_meter>=iss_avgamt){
            String query_issue= "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_issue); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_is_meter);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Grey issue");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                }     //end of if   
                }
               }
               
            }//monthly                                         
        
                                                   
            
}//================================================ Store(Start) ===============================================

 if(role_name.equals("Store")){  
        
       
       //--------------------------------------------------- consumption of Boiler ----------------------------------------
           int cont_boiler=0,cont_boilerr=0;          
           int boiler_indaily=0, boiler_inmonthly=0, boiler_indate=0; 
           String boiler_indays="";
           ResultSet rs_rpavgmin_boi=st.executeQuery("SELECT acon_mincost, acon_avgcost,acon_maxcost, acon_indaily, acon_inday, acon_inmonthly, acon_indate FROM et_alert_consumption WHERE cate_id='cate_8'");
            if(rs_rpavgmin_boi.next()){
            boiler_minamt=rs_rpavgmin_boi.getDouble("acon_mincost");
            boiler_avgamt=rs_rpavgmin_boi.getDouble("acon_avgcost");
            boiler_max=rs_rpavgmin_boi.getDouble("acon_maxcost");
            boiler_indaily=rs_rpavgmin_boi.getInt("acon_indaily");            
            boiler_indays=rs_rpavgmin_boi.getString("acon_inday");
            boiler_inmonthly=rs_rpavgmin_boi.getInt("acon_inmonthly");            
            boiler_indate=rs_rpavgmin_boi.getInt("acon_indate");
           }                         
            
         if(boiler_indaily==1){        
         ResultSet rs_status_b=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Boiler Consumption'");
         while(rs_status_b.next()){ cont_boiler++;}
         if(cont_boiler==0){ 
         ResultSet rs_boiler_issu=st.executeQuery("SELECT SUM(sissue_amt) AS issue_b FROM  et_store_issue  WHERE cate_id='cate_8' AND sissue_modifieddate='"+lastdaydt+"'");
         if(rs_boiler_issu.next()){total_boilercost=rs_boiler_issu.getDouble("issue_b");}                                
         if(total_boilercost>=boiler_minamt)
                 {  
                 String query = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_boilercost);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Boiler Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();     
                    }   
              } //cnt          
         }//daily           
           
    else if(boiler_inmonthly==1){  
         if(dateNow.equals(monthfirstdt)){
         ResultSet rs_status_bb=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Boiler Consumption'");
         while(rs_status_bb.next()){ cont_boilerr++;}
         if(cont_boilerr==0){
              ResultSet rs_boiler=st.executeQuery("SELECT SUM(sissue_amt) AS issue_bb FROM  et_store_issue  WHERE cate_id='cate_8' AND sissue_modifieddate BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'");
              if(rs_boiler.next()){ total_boilercost=rs_boiler.getDouble("issue_bb"); }
              if(total_boilercost>=boiler_minamt)
                 {  
                  String query1 = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query1); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_boilercost);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Boiler amount");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate(); 
                 }  
               }
                 }
            }//monthly
                     
   //-------------------------------------- Consumption(chemical) ----------------------------------------------      
           
        double total_chemical=0.0,chemical_minamt=0.0;
           int cont_chemical=0,cont_chemicall=0;          
           int chemical_indaily=0, chemical_inmonthly=0, chemical_indate=0; 
           String chemical_indays="";
           ResultSet rs_rpavgmin_che=st.executeQuery("SELECT acon_mincost, acon_avgcost,acon_maxcost, acon_indaily, acon_inday, acon_inmonthly, acon_indate FROM et_alert_consumption WHERE cate_id='cate_3'");
            if(rs_rpavgmin_che.next()){
            chemical_minamt=rs_rpavgmin_che.getDouble("acon_mincost");
            chemical_avgamt=rs_rpavgmin_che.getDouble("acon_avgcost");
            chemical_max=rs_rpavgmin_che.getDouble("acon_maxcost");
            chemical_indaily=rs_rpavgmin_che.getInt("acon_indaily");            
            chemical_indays=rs_rpavgmin_che.getString("acon_inday");
            chemical_inmonthly=rs_rpavgmin_che.getInt("acon_inmonthly");            
            chemical_indate=rs_rpavgmin_che.getInt("acon_indate");
           }                         
            
         if(chemical_indaily==1){        
         ResultSet rs_status_b=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Chemical Consumption'");
         while(rs_status_b.next()){ cont_chemical++;}
         if(cont_chemical==0){ 
         ResultSet rs_chemical_issu=st.executeQuery("SELECT SUM(sissue_amt) AS issue_b FROM  et_store_issue  WHERE cate_id='cate_3' AND sissue_modifieddate='"+lastdaydt+"'");
         if(rs_chemical_issu.next()){total_chemical=rs_chemical_issu.getDouble("issue_b");}                                
         if(total_chemical>=boiler_minamt)
                 {  
                 String query_ch = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_ch); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_chemical);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Chemical Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();     
                    }   
              } //cnt          
         }//daily           
           
        else if(chemical_inmonthly==1){  
       if(dateNow.equals(monthfirstdt)){
         ResultSet rs_status_bb=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Chemical Consumption'");
        while(rs_status_bb.next()) { cont_chemicall++;         }
         if(cont_chemicall==0){
              ResultSet rs_chemical=st.executeQuery("SELECT SUM(sissue_amt) AS issue_bb FROM  et_store_issue  WHERE cate_id='cate_3' AND sissue_modifieddate BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'");
              if(rs_chemical.next()){ total_chemical=rs_chemical.getDouble("issue_bb"); }
              if(total_chemical>=boiler_minamt)
                 {  
                  String query_c = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_c); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_chemical);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Chemical Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate(); 
                 }  
               }
                 }
            }//monthly
                        
 //-------------------------------------- Consumption(coal) ----------------------------------------------       
            double total_coal=0.0,coal_minamt=0.0;        
           int cont_coal=0,cont_coall=0;          
           int coal_indaily=0, coal_inmonthly=0, coal_indate=0; 
           String coal_indays="";
           ResultSet rs_rpavgmin_coal=st.executeQuery("SELECT acon_mincost, acon_avgcost,acon_maxcost, acon_indaily, acon_inday, acon_inmonthly, acon_indate FROM et_alert_consumption WHERE cate_id='cate_2'");
            if(rs_rpavgmin_coal.next()){
            coal_minamt=rs_rpavgmin_coal.getDouble("acon_mincost");
            caol_avgamt=rs_rpavgmin_coal.getDouble("acon_avgcost");
            coal_max=rs_rpavgmin_coal.getDouble("acon_maxcost");
            coal_indaily=rs_rpavgmin_coal.getInt("acon_indaily");            
            coal_indays=rs_rpavgmin_coal.getString("acon_inday");
            coal_inmonthly=rs_rpavgmin_coal.getInt("acon_inmonthly");            
            coal_indate=rs_rpavgmin_coal.getInt("acon_indate");
           }                         
            
         if(coal_indaily==1){        
         ResultSet rs_status_coal=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Coal Consumption'");
         while(rs_status_coal.next()){ cont_coal++;}
         if(cont_coal==0){ 
         ResultSet rs_coal_issu=st.executeQuery("SELECT SUM(sissue_amt) AS issue_b FROM  et_store_issue  WHERE cate_id='cate_2' AND sissue_modifieddate='"+lastdaydt+"'");
         if(rs_coal_issu.next()){total_coal=rs_coal_issu.getDouble("issue_b");}                                
         if(total_coal>=coal_minamt)
                 {  
                 String query = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_coal);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Coal Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();     
                    }   
              } //cnt          
         }//daily           
           
    else if(coal_inmonthly==1){ 
    if(dateNow.equals(monthfirstdt)){        
         ResultSet rs_status_bb=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Coal Consumption'");
         while(rs_status_bb.next()){ cont_coall++;}
         if(cont_coall==0){
              ResultSet rs_coal=st.executeQuery("SELECT SUM(sissue_amt) AS issue_bb FROM  et_store_issue  WHERE cate_id='cate_2' AND sissue_modifieddate BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'");
              if(rs_coal.next()){ total_coal=rs_coal.getDouble("issue_bb"); }
              if(total_coal>=coal_minamt)
                 {  
                  String query1 = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query1); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_coal);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Coal Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate(); 
                 }  
               }
                 }
            }//monthly
                     
                     
           
           
//-------------------------------------- Consumption(Etp) ----------------------------------------------
            double ETP_amt=0;
            int ETP_indaily=0, ETP_inmonthly=0, ETP_indate=0,ETP_count=0;  
            String ETP_indays="";
            ResultSet rs_ETP=st.executeQuery("SELECT * FROM et_alert_consumption WHERE cate_id='cate_10'");
            if(rs_ETP.next()){
            ETP_min=rs_ETP.getDouble("acon_mincost");
            ETP_avg=rs_ETP.getDouble("acon_avgcost");
            ETP_max=rs_ETP.getDouble("acon_maxcost");
            ETP_indaily=rs_ETP.getInt("acon_indaily");            
            ETP_indays=rs_ETP.getString("acon_inday");
            ETP_inmonthly=rs_ETP.getInt("acon_inmonthly");            
            ETP_indate=rs_ETP.getInt("acon_indate");
            }    
              
        if(ETP_indaily==1){     
        ResultSet rs_status_ETP=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='ETP Consumption'");
        while(rs_status_ETP.next()){ ETP_count++;}
        if(ETP_count==0){      
        ResultSet rs_ETP_m=st.executeQuery("SELECT sum(sissue_amt) as cons_tot FROM et_store_issue as ssi WHERE cate_id='cate_10' AND ssi.sissue_date='"+lastdaydt+"'");
        if(rs_ETP_m.next()){ ETP_amt=rs_ETP_m.getDouble("cons_tot");}     
        if(ETP_amt>=ETP_min)
              {
                  String query_ETP ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_ETP); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,ETP_amt);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"ETP Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// bill_con
           }
        
         else if(ETP_inmonthly==1){
       if(dateNow.equals(monthfirstdt)){
         ResultSet rs_status_ETP1=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='ETP Consumption'");
         while(rs_status_ETP1.next()){ ETP_count++;}
         if(ETP_count==0){      
         ResultSet rs_ETP_m=st.executeQuery("SELECT sum(sissue_amt) as cons_tot FROM et_store_issue as ssi WHERE cate_id='cate_10' AND ssi.sissue_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");
         if(rs_ETP_m.next()){ ETP_amt=rs_ETP_m.getDouble("cons_tot");}        
         if(ETP_amt>=ETP_min)
              {
                  String query_ETP1 ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_ETP1); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,ETP_amt);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"ETP Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// contrp
               }
            }//monthly if 

//-------------------------------------- Consumption(Diesel) ----------------------------------------------
            double DIS_amt=0;
            int  DIS_indaily=0,DIS_inmonthly=0, DIS_indate=0,DIS_count=0;  
            String DIS_indays="";
            ResultSet rs_DIS=st.executeQuery("SELECT * FROM et_alert_consumption WHERE cate_id='cate_5'");
            if(rs_DIS.next()){
            DIS_min=rs_DIS.getDouble("acon_mincost");
            DIS_avg=rs_DIS.getDouble("acon_avgcost");
            DIS_max=rs_DIS.getDouble("acon_maxcost");
            DIS_indaily=rs_DIS.getInt("acon_indaily");            
            DIS_indays=rs_DIS.getString("acon_inday");
            DIS_inmonthly=rs_DIS.getInt("acon_inmonthly");            
            DIS_indate=rs_DIS.getInt("acon_indate");
            }    
              
        if(DIS_indaily==1){     
        ResultSet rs_status_DIS=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Diesel Consumption'");
        while(rs_status_DIS.next()){ DIS_count++;}
        if(DIS_count==0){      
        ResultSet rs_DIS_m=st.executeQuery("SELECT sum(sissue_amt) as cons_tot FROM et_store_issue as ssi WHERE cate_id='cate_5' AND ssi.sissue_date='"+lastdaydt+"'");
        if(rs_DIS_m.next()){ DIS_amt=rs_DIS_m.getDouble("cons_tot");}     
        if(DIS_amt>=DIS_min)
              {
                  String query_DIS ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_DIS); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,DIS_amt); 
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Diesel Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// bill_con
           }
        
         else if(DIS_inmonthly==1){
         if(dateNow.equals(monthfirstdt)){
         ResultSet rs_status_DIS1=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Diesel Consumption'");
         while(rs_status_DIS1.next()){ DIS_count++;}
         if(DIS_count==0){      
         ResultSet rs_DIS_m=st.executeQuery("SELECT sum(sissue_amt) as cons_tot FROM et_store_issue as ssi WHERE cate_id='cate_5' AND ssi.sissue_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");
         if(rs_DIS_m.next()){ DIS_amt=rs_DIS_m.getDouble("cons_tot");}        
         if(DIS_amt>=DIS_min)
              {
                  String query_DIS1 ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_DIS1);  
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,DIS_amt);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Diesel Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// contrp
             }
            }//monthly if                                                                                                                                                            
//-------------------------------------- Consumption(WATER) ----------------------------------------------
            double WAT_amt=0;
            int  WAT_indaily=0,WAT_inmonthly=0, WAT_indate=0,WAT_count=0;  
            String WAT_indays="";
            ResultSet rs_WAT=st.executeQuery("SELECT * FROM et_alert_consumption WHERE cate_id='cate_1'");
            if(rs_WAT.next()){
            WAT_min=rs_WAT.getDouble("acon_mincost");
            WAT_avg=rs_WAT.getDouble("acon_avgcost");
            WAT_max=rs_WAT.getDouble("acon_maxcost");
            WAT_indaily=rs_WAT.getInt("acon_indaily");            
            WAT_indays=rs_WAT.getString("acon_inday");
            WAT_inmonthly=rs_WAT.getInt("acon_inmonthly");            
            WAT_indate=rs_WAT.getInt("acon_indate");
            }    
              
        if(WAT_indaily==1){     
        ResultSet rs_status_WAT=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Water Consumption'");
        while(rs_status_WAT.next()){ WAT_count++;}
        if(WAT_count==0){      
        ResultSet rs_WAT_m=st.executeQuery("SELECT sum(sissue_amt) as cons_tot FROM et_store_issue as ssi WHERE cate_id='cate_1' AND ssi.sissue_date='"+lastdaydt+"'");
        if(rs_WAT_m.next()){ DIS_amt=rs_WAT_m.getDouble("cons_tot");}     
        if(WAT_amt>=WAT_min)
              {
                  String query_WAT ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_WAT); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,WAT_amt); 
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Water Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// bill_con
           }
        
         else if(WAT_inmonthly==1){
       if(dateNow.equals(monthfirstdt)){
         ResultSet rs_status_WAT1=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Water Consumption'");
         while(rs_status_WAT1.next()){ WAT_count++;}
         if(WAT_count==0){      
         ResultSet rs_WAT_m=st.executeQuery("SELECT sum(sissue_amt) as cons_tot FROM et_store_issue as ssi WHERE cate_id='cate_1' AND ssi.sissue_date BETWEEN'"+lastm_frstdt+"'AND'"+dateNow+"'");
         if(rs_WAT_m.next()){ WAT_amt=rs_WAT_m.getDouble("cons_tot");}        
         if(WAT_amt>=DIS_min)
              {
                  String query_WAT1 ="INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_WAT1);  
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,WAT_amt);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Water Consumption");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();   
                }              
                }// contrp
               }
            }//monthly if                                                                                                                                   
   //-----------------------------store expence------------------------------------------------
              
           double total_st_amt=0.0;        
           int cont_st=0,cont_stl=0;          
           int st_indaily=0, st_inmonthly=0, st_indate=0; 
           String st_indays="";
           ResultSet rs_rpavgmin_st=st.executeQuery("SELECT aeo_minamt, aeo_avgamt, aeo_indaily, aeo_inday, aeo_inmonthly, aeo_indates FROM et_alert_empoth WHERE aeo_mode='Store'");
            if(rs_rpavgmin_st.next()){
            st_mincost=rs_rpavgmin_st.getDouble("aeo_minamt");
            st_avgcost=rs_rpavgmin_st.getDouble("aeo_avgamt");
            st_indaily=rs_rpavgmin_st.getInt("aeo_indaily");            
            st_indays=rs_rpavgmin_st.getString("aeo_inday");
            st_inmonthly=rs_rpavgmin_st.getInt("aeo_inmonthly");            
            st_indate=rs_rpavgmin_st.getInt("aeo_indates");
           }   
    if(st_indaily==1){                  
            ResultSet rs_status_exp=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='D' AND alert_for='Store expence'");
            while(rs_status_exp.next()){ cont_st++;}
            if(cont_st==0){               
            ResultSet rs_store_expence=st.executeQuery("SELECT SUM(item_amt) AS item FROM et_received_item WHERE item_billdate='"+lastdaydt+"'"); 
            while(rs_store_expence.next()){total_st_amt=rs_store_expence.getDouble("item");}  
             if(total_st_amt>=st_avgcost)
                 {  
                 String query_store = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_store); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_st_amt);
                  pstmt.setString(3,"D");
                  pstmt.setString(4,"Store expence");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                 }  
              }                       
              }
                  
    else if(st_inmonthly==1){ 
    if(dateNow.equals(monthfirstdt)){        
         ResultSet rs_status_st=st.executeQuery("Select * from et_alert_statusdetail WHERE role_id='"+role_id+"' AND alert_date='"+dateNow+"' AND alert_mode='M' AND alert_for='Store expence'");
         while(rs_status_st.next()){ cont_stl++;}
         if(cont_stl==0){
             ResultSet rs_store_stex=st.executeQuery("SELECT SUM(item_amt) AS item FROM et_received_item WHERE item_billdate=BETWEEN '"+lastm_frstdt+"'AND'"+dateNow+"'"); 
            while(rs_store_stex.next()){total_st_amt=rs_store_stex.getDouble("item");}  
              
              if(total_st_amt>=st_avgcost)
                 {  
                 String query_store = "INSERT INTO et_alert_statusdetail(role_id, alert_value, alert_mode, alert_for, alert_date, alert_time) VALUES(?,?,?,?,?,?)";
                  pstmt = con.prepareStatement(query_store); 
                  pstmt.setString(1, role_id);
                  pstmt.setDouble(2,total_st_amt);
                  pstmt.setString(3,"M");
                  pstmt.setString(4,"Store expence");
                  pstmt.setString(5,dateNow);
                  pstmt.setString(6,timeNow);
                  pstmt.executeUpdate();
                 }  
               }
                 }
            }//monthly
}//=============================================================================================================        
        if((role_name.equals("System Admin")) || (role_name.equals("General Admin"))){
            
        }
   
 %>  
  