package com.infosys.programs;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Types;

public class GetEmployeeDetails {

	public static void main(String[] args) {
		String url = "jdbc:oracle:thin:@83.229.112.177:1521:orcl";
		String username = "c##u50";
		String password = "u50";
		try (Connection conn = DriverManager.getConnection(url, username, password);
				CallableStatement stmt = conn.prepareCall("call get_emp_details(?,?,?,?,?,?,?)");) {
			
			stmt.setInt(1, 555);
			stmt.registerOutParameter(2, Types.VARCHAR);
			stmt.registerOutParameter(3, Types.VARCHAR);
			stmt.registerOutParameter(4, Types.VARCHAR);
			stmt.registerOutParameter(5, Types.VARCHAR);
			stmt.registerOutParameter(6, Types.NUMERIC);
			stmt.registerOutParameter(7, Types.VARCHAR);
			stmt.execute();
			String empName = stmt.getString(2);
			String deptName = stmt.getString(3);
			String jobTitle = stmt.getString(4);
			String mgrName = stmt.getString(5);
			Double salary = stmt.getDouble(6);
			String workAddress = stmt.getString(7);
			
			System.out.println("Name         : " + empName);
			System.out.println("Department   : " + deptName);
			System.out.println("Job          : " + jobTitle);
			System.out.println("Manager      : " + mgrName);
			System.out.println("Salary       : $" + salary);
			System.out.println("Work address : " + workAddress);
			

		}
		catch (SQLException e) {
			System.out.println("Error code: " + e.getErrorCode());
			System.out.println("Error message: " + e.getMessage());
		}
	}

}
