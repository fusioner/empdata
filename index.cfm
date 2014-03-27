<!DOCTYPE html>

<script src="jquery-2.0.3.min.js" ></script>

<script >
	$(document).ready(function(){
		
		$(document).on("click","#addBtn", function(){
			var firstName = $("#fnTxt").val();
			var lastName = $("#lnTxt").val();
			var city = $("#cityTxt").val();
			
			if (firstName.trim().length == 0)
			{
				alert("First name is required");
				return;
			}
			
			addEmployee(firstName,lastName,city);
		});
	});
</script>

<style >
	th,td {
		text-align:left;
	}	
</style>

<h2>CFMobile Demo:</h2>
This application calls a CFC on the server side to get all employee records from a database table on the server.<br>
You can add an employee by filling up following details and clicking Submit button.
This again makes call to a server CFC to add employee to the table.

<h3>Add Employee:</h3>
<form>
	<table >
		<tr>
			<td>First Name:</td>
			<td><input type="text" id="fnTxt">		
		</tr>
		<tr>
			<td>Last Name:</td>
			<td><input type="text" id="lnTxt">		
		</tr>
		<tr>
			<td>City:</td>
			<td><input type="text" id="cityTxt">		
		</tr>
		<tr>
			<td colspan="2">
				<button type="button" id="addBtn">Add</button>
				<button type="reset">Reset</button>
			</td>
		</tr>
	</table>
</form>
<hr>
	
<h3>Employees:</h3>
<table id="empTable" width="100%">
	<tr>
		<th>First Name</th>
		<th>Last Name</th>
		<th>City</th>
	</tr>
</table>


<cfclient>
	<cfscript>
		try
		{
			empMgr = new EmpServerApp.EmployeeDBManager();
		}
		catch (any e)
		{
			alert("Error : " + e.message);
			cfabort ();
		}

		//get all employees from the server and display in the above HTML table
		getAllEmployees();
		
		//Add a new employee.
		function addEmployee(firstName, lastName, city)
		{
			try
			{
				var newEmp = {"firstName":firstName, "lastName":lastName, "address":city};
				
				//Set callback function on the server CFC, which will be
				//called with the result
				empMgr.setCallbackHandler(function(callbackResult) {
					newEmp.id = callbackResult.result;
					addEmpToHTMLTable(newEmp);
				});
				
				empMgr.addEmployee(newEmp);
			}
			catch (any e)
			{
				alert("Error:" + e.message);
				return;
			} 
		}
		
		//Fetch employees data from server and display in the HTML table
		function getAllEmployees()
		{
			try
			{
				//Set callback function on the server CFC, which will be
				//called with the result
				empMgr.setCallbackHandler(function(callbackResult){
					var employees = callbackResult.result;
					var empCount = arrayLen(employees);
					for (var i = 1; i <= empCount; i++)
					{
						addEmpToHTMLTable(employees[i]);	
					}
				});
				
				empMgr.getEmployees();
			}
			catch (any e)
			{
				alert("Error : " + e.message);
				return;
			}
			
		}
		
	</cfscript>
	
	<!--- Append employee data in the HTML table --->
	<cffunction name="addEmpToHTMLTable" >
		<cfargument name="emp" >
		
		<cfoutput >
			<cfsavecontent variable="rowHtml" >
				<tr>
					<td>#emp.firstName#</td>
					<td>#emp.lastName#</td>
					<td>#emp.address#</td>
				</tr>
			</cfsavecontent>
		</cfoutput>
		
		<cfset $("##empTable").append(rowHtml)>
	</cffunction>
	
</cfclient>