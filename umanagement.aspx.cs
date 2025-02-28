using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Expense_Tracker
{
    public partial class umanagement : System.Web.UI.Page
    {
        string connStr = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=D:\\Expense-Tracker\\Expense-Tracker\\App_Data\\Database1.mdf;Integrated Security=True";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsers();
            }
        }
        private void LoadUsers()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter("SELECT fnm, lnm, mno FROM [user]", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptUsers.DataSource = dt;
                rptUsers.DataBind();
            }
        }

        protected void SaveUser(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string query;
                bool isNewUser = string.IsNullOrEmpty(hfMobileNumber.Value);

                if (isNewUser)
                {
                    // Ensure the mobile number is not already in use
                    SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM [user] WHERE mno = @mno", conn);
                    checkCmd.Parameters.AddWithValue("@mno", txtMobile.Text.Trim());
                    int userExists = (int)checkCmd.ExecuteScalar();

                    if (userExists > 0)
                    {
                        // Display an error message (optional)
                        Response.Write("<script>alert('Mobile number already exists!');</script>");
                        return;
                    }

                    query = "INSERT INTO [user] (fnm, lnm, mno, pwd) VALUES (@fnm, @lnm, @mno, @pwd)";
                }
                else
                {
                    query = "UPDATE [user] SET fnm = @fnm, lnm = @lnm, pwd = @pwd WHERE mno = @mno";
                }

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@fnm", txtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@lnm", txtLastName.Text.Trim());
                    cmd.Parameters.AddWithValue("@mno", txtMobile.Text.Trim());
                    cmd.Parameters.AddWithValue("@pwd", txtPassword.Text.Trim());

                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected == 0)
                    {
                        Response.Write("<script>alert('Failed to save user. Please try again.');</script>");
                    }
                }
            }

            // Refresh user list after adding/updating
            LoadUsers();        
         }

        protected void DeleteUser(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string mno = btn.CommandArgument;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("DELETE FROM [user] WHERE mno = @mno", conn);
                cmd.Parameters.AddWithValue("@mno", mno);
                cmd.ExecuteNonQuery();
            }

            LoadUsers();
        }
    }
}