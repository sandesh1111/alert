<%@include file="../case/dbconnection.jsp"%> 
<%@include file="../case/declaration.jsp"%>
<%@include file="../alert/alert_detail.jsp"%>
<%@ page language="java" import="javax.naming.*,java.io.*,javax.mail.*,javax.mail.internet.*,com.sun.mail.smtp.*"%>

<div  class="SbmPopupTitle">
    <table class="SbmPopupTitleTable">
    <tr><td class="Title">Alerts</td>
    <td class="Close" onclick="new Ajax.Updater('NewAlertMessages', '../alert/alert_list_incl_popup.jsp', {asynchronous:true}); ReverseContentDisplay('NewAlertMessages'); return true;">
        <a href="javascript:;" title="Close"></a>
    </td>
    </tr> 
    </table>
</div><!--SbmPopupTitle-->
<div class="SbmPopupContent">
<div  class="SbmListDiv">
<table class="SbmListTable" id="alerttab"><thead>
	<tr>
	  <th class="SbmNarrowCol">&nbsp;</th>
	  <th class="SbmSortCol SortDesc">Name</th>
	  <th  class="SbmSortCol"></th>
          <th  class="SbmSortCol">Current</th>
	  <!--<th  class="SbmSortCol">Severity</th> -->
	<th class="SbmSortCol">Date</th>
        <th class="SbmSortCol"></th>
	<!-- <th  class="SbmAction ThreeIcons"><p></p></th> -->
	</tr>
	</thead>
	<tbody>
       <!------------------------------------------- Production-------------------------------------------------->     
      <tr onMouseOut="this.className='Even';" class="Even">
       <% 

 //cld.set(Calendar.DAY_OF_YEAR,1);
 //cld.add(Calendar.YEAR,-1);   //last day of the year.     
  
           
//----------------------------------------------------------------------------------
             int counter=0;
          String lab_min="Min val=",lab_avg="Avg val=";          
          double temp=0,temp2=0,val=0; 
       if(dateNow.equals(monthfirstdt)) //-----------------Monthly -----------------
        {   
         ResultSet rs_gr_alt_m=st.executeQuery("SELECT * FROM et_alert_statusdetail WHERE alert_mode='M' AND role_id='"+role_id+"'AND alert_status='OPEN'");
         while(rs_gr_alt_m.next()){ counter++;  
        %> <td><%=counter%></td>
          <% String alert_for=rs_gr_alt_m.getString("alert_for");
          %>
	  <td><%=alert_for%></td>          
      
       <% val=rs_gr_alt_m.getDouble("alert_value");                   
          if(alert_for.equals("Production stock meter")){temp=prd_minmeter; temp2=prg_avgmeter;}
          else if(alert_for.equals("Grey stock meter")){temp=ags_minmeter; temp2=ags_avgmeter;}
          else if(alert_for.equals("Grey issue")){temp=iss_minmeter; temp2=iss_avgamt; lab_min="Min val=";}         
          else if(alert_for.equals("Reprocess Grey stock meter")){temp=rp_minmeter; temp2=rp_avgmeter;}
          else if(alert_for.equals("Billing Amount")){temp=bill_min; temp2=bill_avg;} 
          else if(alert_for.equals("Employee expence amount")){temp=emp_minamt; temp2=emp_avgmeter;} 
          else if(alert_for.equals("Other expence amount")){temp=other_minamt; temp2=other_avgamt;} 
          else if(alert_for.equals("Boiler Consumption")){temp=boiler_avgamt; temp2=boiler_max; lab_min="Max val=";}
          else if(alert_for.equals("Chemical Consumption")){temp=chemical_avgamt; temp2=chemical_max; lab_min="Max val=";}
          else if(alert_for.equals("Coal Consumption")){temp=caol_avgamt; temp2=coal_max; lab_min="Max val=";}                            
          else if(alert_for.equals("ETP Consumption")){temp=ETP_avg; temp2=ETP_max; lab_min="Max val=";}    
          else if(alert_for.equals("Diesel Consumption")){temp=DIS_avg; temp2=DIS_max; lab_min="Max val=";} 
          else if(alert_for.equals("Water Consumption")){temp=WAT_avg; temp2=WAT_max; lab_min="Max val=";}
          else if(alert_for.equals("BSR meter")){temp=bsr_minamt; temp2=bsr_avgamt; lab_min="Min val=";} 
          else if(alert_for.equals("Store expence")){temp=st_mincost; temp2=st_avgcost; lab_min="Min val=";} 
          else if(alert_for.equals("BSR bale")){temp=bsr_minamt; temp2=bsr_avgamt; lab_min="Min val=";} 
          else if(alert_for.equals("Despatch bale")){temp=dis_minm; temp2=dis_avgm; lab_min="Min val=";}  
          else if(alert_for.equals("Revenue detail")){temp=rev_minamt; temp2=rev_avgamt; lab_min="Min val=";}
          else{ lab_min="";lab_avg="";}   
          if(val>=temp && val<=temp2){ //sandesh changing file
          %>
          <td><%=lab_min%><%=temp%><br><%=lab_avg%><%=temp2%></td><td><font color="orange">Current val=<%=val%></font></td>
          <% 
          }else {
          %>
       <td><%=lab_min%><%=temp%><br><%=lab_avg%><%=temp2%></td><td><font color="red">Current val=<%=val%></font></td>
           <% }
          %>      
<!--	<td><p class="SbmPriorityMedium" title="Medium"></p></td>-->
       <% String[] d1=rs_gr_alt_m.getString("alert_date").split("-");  
          String dmy=d1[2]+"-"+d1[1]+"-"+d1[0]; 
          %>
	<td><%=dmy%></td>
        <td><a href="javascript:;" title="Close"><img class="titleIcon" name="alert_close"  id="alert_close" src="../../css/theme01/images/alert_close.png" /></a> <input type="hidden" id="statetxtid" name="statetxtid" value="" /></td>
    <!--  <td class="SbmAction"><span class="IconContainer"><a href="javascript:;" class="SbmInfopad" title="View the associated Infopad"></a> <a href="mailto:" class="SbmEmail" title="Send the alert as an Email"></a> <a href="javascript:;" onclick="new Ajax.Updater('SelectSpecificGroupsUser', '../common/common_incl_popup_select_specific_groups_and_users.jsp', {asynchronous:true}); toggleVisibilityPosition('SelectSpecificGroupsUser','370px','120px','600px'); return true;" class="SbmForward" title="Forward the alert to other users in the system"></a></span></td> -->
	</tr>
       <%
           }//while monthly...
       }//if monthly......
   %> 
   <tr>
  <%  //------------------------------------- Daily Record---------------------------------------------------------------
  
       ResultSet rs_gr_alt=st.executeQuery("SELECT * FROM et_alert_statusdetail WHERE alert_mode='D' AND role_id='"+role_id+"'AND alert_status='OPEN' AND Alert_date='"+dateNow+"'");
       while(rs_gr_alt.next())
       { counter++;
       %>       
	  <td><%=counter%></td>
          <% String alert_for=rs_gr_alt.getString("alert_for");
          %>
	  <td><%=alert_for%></td>          
      
       <% val=rs_gr_alt.getDouble("alert_value"); 
          temp=0;temp2=0;
          lab_min="Min val=";
          lab_avg="Avg val=";
          if(alert_for.equals("Production stock meter")){temp=prd_minmeter; temp2=prg_avgmeter;}
          else if(alert_for.equals("Grey stock meter")){temp=ags_minmeter; temp2=ags_avgmeter;} 
          else if(alert_for.equals("Grey issue")){temp=iss_minmeter; temp2=iss_avgamt; lab_min="Min val=";}  
          else if(alert_for.equals("Reprocess Grey stock meter")){temp=rp_minmeter; temp2=rp_avgmeter;}
          else if(alert_for.equals("Billing Amount")){temp=bill_min; temp2=bill_avg;} 
          else if(alert_for.equals("Employee expence amount")){temp=emp_minamt; temp2=emp_avgmeter;} 
          else if(alert_for.equals("Other expence amount")){temp=other_minamt; temp2=other_avgamt;} 
          else if(alert_for.equals("Boiler Consumption")){temp=boiler_avgamt; temp2=boiler_max; lab_min="Max val=";}
          else if(alert_for.equals("Chemical Consumption")){temp=chemical_avgamt; temp2=chemical_max; lab_min="Max val=";}
          else if(alert_for.equals("Coal Consumption")){temp=caol_avgamt; temp2=coal_max; lab_min="Max val=";}                            
          else if(alert_for.equals("ETP Consumption")){temp=ETP_avg; temp2=ETP_max; lab_min="Max val=";}    
          else if(alert_for.equals("Diesel Consumption")){temp=DIS_avg; temp2=DIS_max; lab_min="Max val=";} 
          else if(alert_for.equals("Store expence")){temp=st_mincost; temp2=st_avgcost; lab_min="Min val=";}
          else if(alert_for.equals("Water Consumption")){temp=WAT_avg; temp2=WAT_max; lab_min="Max val=";} 
          else if(alert_for.equals("BSR meter")){temp=bsr_minamt; temp2=bsr_avgamt; lab_min="Min val=";}
          else if(alert_for.equals("Despatch bale")){temp=dis_minm; temp2=dis_avgm; lab_min="Min val=";} 
          else if(alert_for.equals("BSR bale")){temp=bale_minamt; temp2=bale_avgamt; lab_min="Min val=";}   
          else{ lab_min="";lab_avg="";}
          if(val>temp && val<temp2){
          %>
          <td><%=lab_min%><%=temp%><br><%=lab_avg%><%=temp2%></td><td><font color="orange">Current val=<%=val%></font></td>
          <% 
          }else {
          %>
       <td><%=lab_min%><%=temp%><br><%=lab_avg%><%=temp2%></td><td><font color="red">Current val=<%=val%></font></td>
           <% }
          %>      
<!--	<td><p class="SbmPriorityMedium" title="Medium"></p></td>-->
       <% String[] d1=rs_gr_alt.getString("alert_date").split("-");  
      String dmy=d1[2]+"-"+d1[1]+"-"+d1[0]; //lastdaydt_M
          %>
	<td><%=dmy%></td> 
        <%//=rs_gr_alt.getString("alert_id")%>
        <td><img class="titleIcon" alt="Click Me" src="../../css/theme01/images/alert_close.png" onclick='getalert("<%=rs_gr_alt.getString("alert_id")%>")' onmouseover="getalert('hiiiiiiiiii');"/><input type="hidden" name="alt_id" id="alt_id" value="<%=rs_gr_alt.getString("alert_id")%>"/></td>
    <!--  <td class="SbmAction"><span class="IconContainer"><a href="javascript:;" class="SbmInfopad" title="View the associated Infopad"></a> <a href="mailto:" class="SbmEmail" title="Send the alert as an Email"></a> <a href="javascript:;" onclick="new Ajax.Updater('SelectSpecificGroupsUser', '../common/common_incl_popup_select_specific_groups_and_users.jsp', {asynchronous:true}); toggleVisibilityPosition('SelectSpecificGroupsUser','370px','120px','600px'); return true;" class="SbmForward" title="Forward the alert to other users in the system"></a></span></td> -->
	</tr>
       <%
           }//while
       
       %>   
    
  <tr>
 <% //-------------------------------------First Quarterly Record---------------------------------------------------------------
       
       if(dateNow.equals(Q2_fdate)){ 
       double val_y=0;
       ResultSet rs_year=st.executeQuery("SELECT * FROM et_alert_statusdetail WHERE alert_mode='Q1' AND role_id='"+role_id+"'AND alert_status='OPEN' AND Alert_date='"+dateNow+"'");
       while(rs_year.next())
       { counter++;
       %>       
	  <td><%=counter%></td>
          <% String alert_for=rs_year.getString("alert_for");
          %>
	  <td><%=alert_for%></td>         
      
       <% val_y=rs_year.getDouble("alert_value"); 
          double temp_y=0,temp2_y=0;
          lab_min="Min val=";
          lab_avg="Avg val=";
          if(alert_for.equals("Production stock meter")){temp_y=arv_minamt_qtr; temp2_y=arv_avgamt_qtr;}           
          if(val_y>temp_y && val_y<temp2_y){
          %>
          <td><%=lab_min%><%=temp_y%><br><%=lab_avg%><%=temp2_y%></td><td><font color="orange">Current val=<%=val_y%></font></td>
          <% 
          }else {
          %>
       <td><%=lab_min%><%=temp_y%><br><%=lab_avg%><%=temp2_y%></td><td><font color="red">Current val=<%=val_y%></font></td>
           <% }
          %>      
<!--	<td><p class="SbmPriorityMedium" title="Medium"></p></td>-->
       <% String[] d2=rs_year.getString("alert_date").split("-");  
          String dmy2=d2[2]+"-"+d2[1]+"-"+d2[0]; //lastdaydt_M
          %>
	<td><%=dmy2%></td> 
       
        <td><a href="#"><img class="titleIcon" src="../../css/theme01/images/alert_close.png" /></a></td>
    <!--  <td class="SbmAction"><span class="IconContainer"><a href="javascript:;" class="SbmInfopad" title="View the associated Infopad"></a> <a href="mailto:" class="SbmEmail" title="Send the alert as an Email"></a> <a href="javascript:;" onclick="new Ajax.Updater('SelectSpecificGroupsUser', '../common/common_incl_popup_select_specific_groups_and_users.jsp', {asynchronous:true}); toggleVisibilityPosition('SelectSpecificGroupsUser','370px','120px','600px'); return true;" class="SbmForward" title="Forward the alert to other users in the system"></a></span></td> -->
	</tr>
      <tr>
       <%
           }//while
          }//if yearly
  //-------------------------------------Scond Quarterly Record---------------------------------------------------------------
       
       if(dateNow.equals(Q3_fdate)){
       double val_y=0;
       ResultSet rs_year=st.executeQuery("SELECT * FROM et_alert_statusdetail WHERE alert_mode='Q2' AND role_id='"+role_id+"'AND alert_status='OPEN' AND Alert_date='"+dateNow+"'");
       while(rs_year.next())
       { counter++;
       %>       
	  <td><%=counter%></td>
          <% String alert_for=rs_year.getString("alert_for");
          %>
	  <td><%=alert_for%></td>          
      
       <% val_y=rs_year.getDouble("alert_value"); 
          double temp_y=0,temp2_y=0;
          lab_min="Min val=";
          lab_avg="Avg val=";
          if(alert_for.equals("Production stock meter")){temp_y=arv_minamt_qtr; temp2_y=arv_avgamt_qtr;}           
          if(val_y>temp_y && val_y<temp2_y){
          %>
          <td><%=lab_min%><%=temp_y%><br><%=lab_avg%><%=temp2_y%></td><td><font color="orange">Current val=<%=val_y%></font></td>
          <% 
          }else {
          %>
       <td><%=lab_min%><%=temp_y%><br><%=lab_avg%><%=temp2_y%></td><td><font color="red">Current val=<%=val_y%></font></td>
           <% }
          %>      
<!--	<td><p class="SbmPriorityMedium" title="Medium"></p></td>-->
       <% String[] d2=rs_year.getString("alert_date").split("-");  
          String dmy2=d2[2]+"-"+d2[1]+"-"+d2[0]; //lastdaydt_M
          %>
	<td><%=dmy2%></td> 
       
        <td><a href="#"><img class="titleIcon" src="../../css/theme01/images/alert_close.png" /></a></td>
    <!--  <td class="SbmAction"><span class="IconContainer"><a href="javascript:;" class="SbmInfopad" title="View the associated Infopad"></a> <a href="mailto:" class="SbmEmail" title="Send the alert as an Email"></a> <a href="javascript:;" onclick="new Ajax.Updater('SelectSpecificGroupsUser', '../common/common_incl_popup_select_specific_groups_and_users.jsp', {asynchronous:true}); toggleVisibilityPosition('SelectSpecificGroupsUser','370px','120px','600px'); return true;" class="SbmForward" title="Forward the alert to other users in the system"></a></span></td> -->
	</tr>
        <tr>
       <%
           }//while
          }//if yearly
       %> 
       <%
        //-------------------------------------Third Quarterly Record---------------------------------------------------------------
       
       if(dateNow.equals(Q4_fdate)){
       double val_y=0;
       ResultSet rs_year=st.executeQuery("SELECT * FROM et_alert_statusdetail WHERE alert_mode='Q3' AND role_id='"+role_id+"'AND alert_status='OPEN' AND Alert_date='"+dateNow+"'");
       while(rs_year.next())
       { counter++;
       %>       
	  <td><%=counter%></td>
          <% String alert_for=rs_year.getString("alert_for");
          %>
	  <td><%=alert_for%></td>          
      
       <% val_y=rs_year.getDouble("alert_value"); 
          double temp_y=0,temp2_y=0;
          lab_min="Min val=";
          lab_avg="Avg val=";
          if(alert_for.equals("Production stock meter")){temp_y=arv_minamt_qtr; temp2_y=arv_avgamt_qtr;}           
          if(val_y>temp_y && val_y<temp2_y){
          %>
          <td><%=lab_min%><%=temp_y%><br><%=lab_avg%><%=temp2_y%></td><td><font color="orange">Current val=<%=val_y%></font></td>
          <% 
          }else {
          %>
       <td><%=lab_min%><%=temp_y%><br><%=lab_avg%><%=temp2_y%></td><td><font color="red">Current val=<%=val_y%></font></td>
           <% }
          %>      
<!--	<td><p class="SbmPriorityMedium" title="Medium"></p></td>-->
       <% String[] d2=rs_year.getString("alert_date").split("-");  
          String dmy2=d2[2]+"-"+d2[1]+"-"+d2[0]; //lastdaydt_M
          %>
	<td><%=dmy2%></td> 
       
        <td><a href="#"><img class="titleIcon" src="../../css/theme01/images/alert_close.png" /></a></td>
    <!--  <td class="SbmAction"><span class="IconContainer"><a href="javascript:;" class="SbmInfopad" title="View the associated Infopad"></a> <a href="mailto:" class="SbmEmail" title="Send the alert as an Email"></a> <a href="javascript:;" onclick="new Ajax.Updater('SelectSpecificGroupsUser', '../common/common_incl_popup_select_specific_groups_and_users.jsp', {asynchronous:true}); toggleVisibilityPosition('SelectSpecificGroupsUser','370px','120px','600px'); return true;" class="SbmForward" title="Forward the alert to other users in the system"></a></span></td> -->
	</tr>
       <%
           }//while
          }//if yearly
       %>  
       <tr>
        <% //-------------------------------------Fourth Quarterly Record---------------------------------------------------------------
       
       if(dateNow.equals(Q1_fdate)){ 
       double val_y=0;
       ResultSet rs_year=st.executeQuery("SELECT * FROM et_alert_statusdetail WHERE alert_mode='Q4' AND role_id='"+role_id+"'AND alert_status='OPEN' AND Alert_date='"+dateNow+"'");
       while(rs_year.next())
       { counter++;
       %>       
	  <td><%=counter%></td>
          <% String alert_for=rs_year.getString("alert_for");
          %>
	  <td><%=alert_for%></td>          
      
       <% val_y=rs_year.getDouble("alert_value"); 
          double temp_y=0,temp2_y=0;
          lab_min="Min val=";
          lab_avg="Avg val=";
          if(alert_for.equals("Production stock meter")){temp_y=arv_minamt_qtr; temp2_y=arv_avgamt_qtr;}           
          if(val_y>temp_y && val_y<temp2_y){
          %>
          <td><%=lab_min%><%=temp_y%><br><%=lab_avg%><%=temp2_y%></td><td><font color="orange">Current val=<%=val_y%></font></td>
          <% 
          }else {
          %>
       <td><%=lab_min%><%=temp_y%><br><%=lab_avg%><%=temp2_y%></td><td><font color="red">Current val=<%=val_y%></font></td>
           <% }
          %>      
<!--	<td><p class="SbmPriorityMedium" title="Medium"></p></td>-->
       <% String[] d2=rs_year.getString("alert_date").split("-");  
          String dmy2=d2[2]+"-"+d2[1]+"-"+d2[0]; //lastdaydt_M
          %>
	<td><%=dmy2%></td> 
       
        <td><a href="#"><img class="titleIcon" src="../../css/theme01/images/alert_close.png" /></a></td>
    <!--  <td class="SbmAction"><span class="IconContainer"><a href="javascript:;" class="SbmInfopad" title="View the associated Infopad"></a> <a href="mailto:" class="SbmEmail" title="Send the alert as an Email"></a> <a href="javascript:;" onclick="new Ajax.Updater('SelectSpecificGroupsUser', '../common/common_incl_popup_select_specific_groups_and_users.jsp', {asynchronous:true}); toggleVisibilityPosition('SelectSpecificGroupsUser','370px','120px','600px'); return true;" class="SbmForward" title="Forward the alert to other users in the system"></a></span></td> -->
	</tr>
       <%
           }//while
          }//if yearly
       %>          
       
       
       
       
     <tr>
 <% //------------------------------------- Yearly Record---------------------------------------------------------------
       
       if(dateNow.equals(cur_yrfdt)){
        double val_y=0;
        ResultSet rs_year=st.executeQuery("SELECT * FROM et_alert_statusdetail WHERE alert_mode='Y' AND role_id='"+role_id+"'AND alert_status='OPEN' AND Alert_date='"+dateNow+"'");
       while(rs_year.next())
       { counter++;
       %>       
	  <td><%=counter%></td>
          <% String alert_for=rs_year.getString("alert_for");
          %>
	  <td><%=alert_for%></td>          
      
       <% val_y=rs_year.getDouble("alert_value"); 
          double temp_y=0,temp2_y=0;
          lab_min="Min val=";
          lab_avg="Avg val=";
          if(alert_for.equals("Production stock meter")){temp_y=prd_minmeter; temp2_y=prg_avgmeter;}          
          if(val_y>temp_y && val_y<temp2_y){
          %>
          <td><%=lab_min%><%=temp_y%><br><%=lab_avg%><%=temp2_y%></td><td><font color="orange">Current val=<%=val_y%></font></td>
          <% 
          }else {
          %>
       <td><%=lab_min%><%=temp_y%><br><%=lab_avg%><%=temp2_y%></td><td><font color="red">Current val=<%=val_y%></font></td>
           <% }
          %>      
<!--	<td><p class="SbmPriorityMedium" title="Medium"></p></td>-->
       <% String[] d2=rs_year.getString("alert_date").split("-");  
          String dmy2=d2[2]+"-"+d2[1]+"-"+d2[0]; //lastdaydt_M
          %>
	<td><%=dmy2%></td> 
       
        <td><a href="#"><img class="titleIcon" src="../../css/theme01/images/alert_close.png" /></a></td>
    <!--  <td class="SbmAction"><span class="IconContainer"><a href="javascript:;" class="SbmInfopad" title="View the associated Infopad"></a> <a href="mailto:" class="SbmEmail" title="Send the alert as an Email"></a> <a href="javascript:;" onclick="new Ajax.Updater('SelectSpecificGroupsUser', '../common/common_incl_popup_select_specific_groups_and_users.jsp', {asynchronous:true}); toggleVisibilityPosition('SelectSpecificGroupsUser','370px','120px','600px'); return true;" class="SbmForward" title="Forward the alert to other users in the system"></a></span></td> -->
	</tr>
       <%
           }//while
          }//if yearly
       %>       
           
       
</tbody>
	</table>
</div> 
<!--close div.SbmListDiv-->

<div class="SbmButton SbmButtonPopup"><table><tr>
<td onmousedown="this.className='Press';" onmouseout="this.className='';"><a href="javascript:;"><b>Hide</b></a></td>
<td class="Separator"></td>
<td onmousedown="this.className='Press';" onmouseout="this.className='';"><a href="javascript:;"><b>Cancel</b></a></td>
</tr></table></div><!--close div.SbmButton-->
   <%@include file="../advertise/advertise_alert.jsp" %>
   
   
<!-- Ajax For close alert-->
        <script language="Javascript 1.2" type="text/javascript">
           function getalert(alertid){                        
                    xmlHttp=GetXmlHttpObject();
                    if (xmlHttp==null){
                        alert ("Browser does not support HTTP Request")
                        return
                    }
                    var url="../case/getalertupdate.jsp";
                    url=url+"?stateidp="+alertid;
                    alert(alertid);
                    xmlHttp.onreadystatechange=alertChanged;
                    xmlHttp.open("GET",url,true);
                    xmlHttp.send(null);
          }
          
          function alertChanged(){
              alert("I m in alertChanged");
              
          }
    function GetXmlHttpObject(){
            var xmlHttp=null;        
            try{
                // Firefox, Opera 8.0+, Safari
                xmlHttp=new XMLHttpRequest();
            }
            catch (e){
                //Internet Explorer
                try{
                    xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
                }
                catch (e){
                    xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
                }
            }
            return xmlHttp;
        }
        </script> 
<script language="Javascript 1.2" type="text/javascript">
   function hello(){
    {
        alert('Image Clicked Action is here')
    }
</script>