<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="umanagement.aspx.cs" Inherits="Expense_Tracker.umanagement" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #121212;
            color: white;
            display: flex;
            height: 100vh;
        }

        .main-container {
            display: flex;
            width: 100%;
            height: 100vh;
        }

        .sidebar {
            width: 250px;
            background-color: #1E1E1E;
            height: 100vh;
            padding: 20px;
            box-shadow: 2px 0px 10px rgba(0, 0, 0, 0.5);
            flex-shrink: 0;
        }

        .sidebar h2 {
            color: #4CAF50;
            text-align: center;
        }

        .sidebar a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 10px;
            margin: 5px 0;
            border-radius: 5px;
            transition: 0.3s;
        }

        .sidebar a:hover {
            background-color: #4CAF50;
        }

        .content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            padding: 20px;
        }
        
        .table-container {
            background: #1E1E1E;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #444;
        }

        th {
            background-color: #4CAF50;
        }

        .btn {
            padding: 8px 12px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            margin-right: 5px;
        }

        .btn:hover {
            background-color: #367c39;
        }

        .btn-delete {
            background-color: #d9534f;
        }

        .btn-delete:hover {
            background-color: #c9302c;
        }

        .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.7);
        backdrop-filter: blur(5px);
        justify-content: center;
        align-items: center;
    }

    /* Modal Content Box */
    .modal-content {
        background: #1e1e1e;
        color: white;
        padding: 20px;
        border-radius: 10px;
        width: 350px;
        max-width: 90%;
        position: relative;
        text-align: center;
        box-shadow: 0 4px 8px rgba(255, 255, 255, 0.2);
        animation: fadeIn 0.3s ease-in-out;
    }

    /* Form Styling */
    label {
        display: block;
        font-size: 14px;
        margin: 8px 0 5px;
        text-align: left;
    }

    input[type="text"], input[type="password"] {
        width: 100%;
        padding: 10px;
        margin-bottom: 10px;
        border: 1px solid #444;
        border-radius: 5px;
        background: #2e2e2e;
        color: white;
    }

        .close {
            float: right;
            cursor: pointer;
        }
        </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-container"> <!-- Main Flex Container -->
    <div class="sidebar">
        <h2>Admin Panel</h2>
        <a href="adashbord.aspx">Dashboard</a>
        <a href="umanagement.aspx">User Management</a>
        <a href="ExpenseManagement.aspx">Expense Management</a>
        <a href="Report.aspx">Reports</a>
        <a href="Settings.aspx">Settings</a>
        <a href="Logout.aspx">Logout</a>
    </div>

    <div class="content">
        <h2>User Management</h2>
                
                <div class="table-container">
                    <asp:Repeater ID="rptUsers" runat="server">
                        <HeaderTemplate>
                            <table>
                                <tr>
                                    <th>First Name</th>
                                    <th>Last Name</th>
                                    <th>Mobile No</th>
                                    <th>Actions</th>
                                </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><%# Eval("fnm") %></td>
                                <td><%# Eval("lnm") %></td>
                                <td><%# Eval("mno") %></td>
                                <td>
                                    <button type="button" class="btn" onclick="editUser('<%# Eval("fnm") %>', '<%# Eval("lnm") %>', '<%# Eval("mno") %>')">Edit</button>
                                    <asp:Button ID="btnDelete" runat="server" CssClass="btn btn-delete" CommandArgument='<%# Eval("mno") %>' OnClick="DeleteUser" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this user?');" />
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>
            </div>
    </div>
        <div id="userModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h3 id="modalTitle">Add User</h3>
                <asp:HiddenField ID="hfMobileNumber" runat="server" />
                <label>First Name:</label>
                <asp:TextBox ID="txtFirstName" runat="server"></asp:TextBox><br />
                <label>Last Name:</label>
                <asp:TextBox ID="txtLastName" runat="server"></asp:TextBox><br />
                <label>Mobile No:</label>
                <asp:TextBox ID="txtMobile" runat="server"></asp:TextBox><br />
                <label>Password:</label>
                <asp:TextBox ID="txtPassword" runat="server"></asp:TextBox><br />
                <asp:Button ID="btnSave" runat="server" CssClass="btn" OnClick="SaveUser" Text="Save" />
            </div>
        </div>
    </form>
    <script>
            function openModal() {
                document.getElementById('userModal').style.display = 'flex';
            }

            function closeModal() {
                document.getElementById('userModal').style.display = 'none';
            }

            function editUser(fnm, lnm, mno) {
                document.getElementById('<%= txtFirstName.ClientID %>').value = fnm;
                document.getElementById('<%= txtLastName.ClientID %>').value = lnm;
                document.getElementById('<%= txtMobile.ClientID %>').value = mno;
                document.getElementById('<%= hfMobileNumber.ClientID %>').value = mno;
                document.getElementById('modalTitle').innerText = 'Edit User';
                openModal();
            }
        </script>
</body>
</html>
