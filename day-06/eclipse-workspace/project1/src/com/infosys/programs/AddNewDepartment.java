package com.infosys.programs;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class AddNewDepartment {
	public static void main(String[] args) {

		String url = "jdbc:oracle:thin:@83.229.112.177:1521:orcl";
		String username = "c##u50";
		String password = "u50";
		try (Connection conn = DriverManager.getConnection(url, username, password);
				CallableStatement stmt = conn.prepareCall("call add_new_dept(?,?,?)");) {

//			stmt.setNull(1, Types.VARCHAR);
//			stmt.setNull(2, Types.INTEGER);
//			stmt.setNull(3, Types.INTEGER);
			
//			stmt.setString(1, "Research and Development");
//			stmt.setNull(2, Types.INTEGER);
//			stmt.setNull(3, Types.INTEGER);
			
//			stmt.setString(1, "Research and Development");
//			stmt.setInt(2, 999);
//			stmt.setNull(3, Types.INTEGER);
			
//			stmt.setString(1, "Research and Development");
//			stmt.setInt(2, 200);
//			stmt.setNull(3, Types.INTEGER);

//			stmt.setString(1, "Research and Development");
//			stmt.setInt(2, 128);
//			stmt.setInt(3, 3400);
			
//			stmt.setString(1, "Research and Development%%%%%%%%%%%%%%%%%%%%%%%%%%");
//			stmt.setInt(2, 128);
//			stmt.setInt(3, 3300);

			stmt.setString(1, "Research and Development");
			stmt.setInt(2, 128);
			stmt.setInt(3, 3300);
			
			
			stmt.execute();
			System.out.println("New department added successfully!");

		} // conn.close() and stmt.close() called automatically here
		catch (SQLException e) {
			System.out.println("Error code: " + e.getErrorCode());
			System.out.println("Error message: " + e.getMessage());
		}
	}
}
