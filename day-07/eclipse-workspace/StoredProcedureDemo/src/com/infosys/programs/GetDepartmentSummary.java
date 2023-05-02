package com.infosys.programs;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;

import com.infosys.utils.DbUtil;

public class GetDepartmentSummary {

	public static void main(String[] args) throws Exception {
		try (Connection conn = DbUtil.createConnection();
				CallableStatement cs = conn.prepareCall("call get_dept_summary()"); // first round trip to db here
		) {

			cs.execute(); // 2nd round trip to db here
			
			try(ResultSet rs = cs.getResultSet();){
				
				System.out.printf("%-20s %5s %10s%n", "Dept name", "Emp#", "Payout");
				while(rs.next()) {
					String deptName = rs.getString(1);
					int empCount = rs.getInt(2);
					double totalSalary = rs.getDouble(3);
					
					System.out.printf("%-20s %5d %10.2f%n", deptName, empCount, totalSalary);
				}
				
			}// rs.close() called here
			
			

		} // conn.close() and cs.close() called here
	}
}
