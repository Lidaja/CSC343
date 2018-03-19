import java.sql.*;
import java.util.List;

// If you are looking for Java data structures, these are highly useful.
// Remember that an important part of your mark is for doing as much in SQL (not Java) as you can.
// Solutions that use only or mostly Java will not receive a high mark.
import java.util.ArrayList;
//import java.util.Map;
//import java.util.HashMap;
//import java.util.Set;
//import java.util.HashSet;
public class Assignment2 extends JDBCSubmission {

    public Assignment2() throws ClassNotFoundException {

        Class.forName("org.postgresql.Driver");
    }

    @Override
    public boolean connectDB(String url, String username, String password) {
	try
	{
		connection = DriverManager.getConnection(url, username,password);
		return true;
	}
	catch (SQLException se)
	{
		System.err.println("SQL Exception." + "<Message>: " + se.getMessage());
		return false;
	}
    }

    @Override
    public boolean disconnectDB() {
        try {
		connection.close();
		return true;
	}
	catch (SQLException se)
	{
		System.err.println("SQL Exception." + "<Message>: " + se.getMessage());
		return false;
	}
	
    }

    @Override
    public ElectionCabinetResult electionSequence(String countryName) {
	try
	{
		List<Integer> e = new ArrayList<Integer>();
		List<Integer> c = new ArrayList<Integer>();
		String queryString = "SELECT country.id as cid, country.name as cname, election.id as eid, e_date, e_type, start_date, cabinet.id as cabid "
				   +"FROM country JOIN election ON country.id = election.country_id JOIN cabinet ON cabinet.election_id = election.id "
				   +"WHERE country.name = ? "
				   +"ORDER BY e_date DESC, start_date ASC;";
		PreparedStatement as = connection.prepareStatement(queryString);
		as.setString(1, countryName);
		ResultSet rs;
		rs = as.executeQuery();
		while (rs.next())
		{
			Integer eid = rs.getInt("eid");
			Integer cabid = rs.getInt("cabid");
			if (!e.contains(eid))
			{
				e.add(eid);
			}
			c.add(cabid);
		}

		ElectionCabinetResult ECR = new ElectionCabinetResult(e,c); 
		return ECR;

	}catch(SQLException se)
	{
		System.err.println("SQL Exception." + "<Message>: " + se.getMessage());
        	return null;
	}
    }

    @Override
    public List<Integer> findSimilarPoliticians(Integer politicianName, Float threshold) {
	List<Integer> similarPresidents = new ArrayList<Integer>();
	try
	{
		String queryString = "SELECT p1.id as id1, p1.description as d1, p1.comment as c1, "
				 +"p2.id as id2, p2.description as d2, p2.comment as c2 " 
				 +"FROM politician_president as p1, politician_president as p2 "
				 +"WHERE p1.id = ? AND p1.id < p2.id;";
		PreparedStatement as = connection.prepareStatement(queryString);
		as.setInt(1, politicianName);
		ResultSet rs;
		rs = as.executeQuery();
		while (rs.next()){
			Integer id1 = rs.getInt("id1");
			Integer id2 = rs.getInt("id2");
			String desc1 = rs.getString("d1");
			String desc2 = rs.getString("d2");
			String comm1 = rs.getString("c1");
			String comm2 = rs.getString("c2");
			double sim = similarity(desc1.concat(comm1),desc2.concat(comm2));
			if (sim >= threshold)
			{
				similarPresidents.add(id2);
			}
		}
		
	} catch(SQLException se)
	{
		System.err.println("SQL Exception." + "<Message>: " + se.getMessage());
	}
        return similarPresidents;
    }

    public static void main(String[] args) {
        // You can put testing code in here. It will not affect our autotester.
        System.out.println("Hello");
	try
	{
		Assignment2 a2 = new Assignment2();
		a2.connectDB("jdbc:postgresql://localhost:5432/csc343h-jacks233?currentSchema=parlgov","jacks233","");
		System.out.println("Connected");
		List<Integer> myList = a2.findSimilarPoliticians(148,0.1f);
		myList.forEach(System.out::println);
		a2.electionSequence("France");
		a2.disconnectDB();
        	System.out.println("Disconnected");
	} catch (ClassNotFoundException C){
		System.err.println("Class not found");
	}
	
    }

}

