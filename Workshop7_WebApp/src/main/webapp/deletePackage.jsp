<%--
Author: Hugo Schrupp;
Co-Author: , Group 6: ;
PROJ-207 Threaded Project, Stage 3, Group 6, Workshop #7 (JSP/Servlets),
OOSD program, SAIT, March-May 2022;
This app creates a Web application to send JSON requests from the REST app.
This is the class to delete packages
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<%--adds view for header--%>
<header>
    <jsp:include page="header.jsp" />
</header>
<head>
    <meta charset="UTF-8">
    <title>Package display</title>
    <script   src="https://code.jquery.com/jquery-3.6.0.js"   integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk="   crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/dayjs/1.11.1/dayjs.min.js"></script>
    <script>
        //function to get all packages from db and put them into an option box
        async function fetchPackages()
        {
            //url for packages from REST app
            var url = "http://localhost:8080/api/packages";
            var packages = await fetch(url);
            var packagesJSON = await packages.json();
            //loop adding each package to the option list
            for (i=0; i<packagesJSON.length; i++)
            {
                $("#packageselect").append("<option value='" + packagesJSON[i].packageId + "'>"
                    + packagesJSON[i].pkgName + "</option>");
            }
        }

        //function to get a specific package from db based off of its ID
        async function fetchPackage(id) {
            //url for get packages from REST app
            var url = "http://localhost:8080/api/getpackage/" + id;
            var response = await fetch(url);
            //if unable to fetch package error occurs
            if (!response.ok)
            {
                throw new Error("Error occurred, status code = " + response.status);
            }

            var packageJSON = await response.json();
            //when package is chosen title text appears
            $("#packageText").html("Package Details")

            //adds text for each element of the package
            $("#PackageId").html("ID: " + packageJSON.packageId);
            $("#PkgName").html("Package Name: " + packageJSON.pkgName);
            //date formatter
            var startdate = dayjs(packageJSON.pkgStartDate).format("YYYY-MM-DD");
            $("#PkgStartDate").html("Start Date: " + startdate);
            var enddate = dayjs(packageJSON.pkgEndDate).format("YYYY-MM-DD");
            $("#PkgEndDate").html("End Date: " + enddate);
            $("#PkgDesc").html("Description: " + packageJSON.pkgDesc);
            var basePrice = (packageJSON.pkgBasePrice).toFixed(2);
            $("#PkgBasePrice").html("Base Price: $" + basePrice);
            var commission = (packageJSON.pkgAgencyCommission).toFixed(2);
            $("#PkgAgencyCommission").html("Commission: $" + commission);
        }

        //function to get the products associated with the chosen package
        async function fetchProducts(id) {
            //url for get products from REST app
            var url = "http://localhost:8080/api/getproducts/" + id;
            var response = await fetch(url);
            //if unable to fetch products error occurs
            if (!response.ok)
            {
                throw new Error("Error occurred, status code = " + response.status);
            }

            var productsJSON = await response.json();
            var tableData = ""; //variable for products table data
            //variable to fill in table headers
            var tableHead = '<tr>' +
                '<th>ID</th>' +
                '<th>Name</th>' +
                '</tr>'
            //when product is chosen title text appears
            $("#productsText").html("Available Products")

            //loop the fills in table data with products
            for (i=0; i<productsJSON.length; i++)
            {
                tableData += '<tr>' +
                    '<td>' + productsJSON[i].productId + '</td>' +
                    '<td>' + productsJSON[i].prodName + '</td>' +
                    '</tr>'
            }
            //adds html to table body
            $("#productsTable>tbody").html(tableData);
            //adds html to table head
            $("#productsTable>thead").html(tableHead);

        }

        //function to delete the chosen package
        async function deletePackage()
        {
            var num = ($("#PackageId").html()).toString();
            var url = "http://localhost:8080/api/deletepackage/" + num.substring(4);


            try {
                const response = await fetch(url,
                    {
                        method: "delete"
                    });
                if (!response.ok) {
                    const message = "Delete failed: status=" + response.status;
                    throw new Error(message);
                }
                const data = await response.json();
                $("#message").html(data.message);
            } catch (e) {
                console.log("Error: " + e);
            }
        }
        // function asks for confirmation to delete, displays confirmation message and reloads the page
        function confirmDelete() {
            var r = confirm("Are you sure you want to delete this package?");
            if (r == true) {
            //User Pressed okay. Delete
                deletePackage()
                alert("Package Deleted")
                window.location.reload();
            } else {
            //user pressed cancel. Do nothing
            }
        }

    </script>
</head>
<body  id="bckgrnd">
<div id="getPckgForm">
<h1>Select a package to delete:</h1>
<%--package selection option, Initiates fetchPackage and fetchProducts when selection is made--%>
<select id="packageselect" onchange="fetchPackage(this.value), fetchProducts(this.value)">
    <option value="">Select a package to view details and then press Delete</option>
</select><br /><br />
<h4 id="packageText"></h4>
<div id="packageDetails">
    <%--each line has an id to be used to fill in data--%>
    <p id="PackageId"></p>
    <p id="PkgName"></p>
    <p id="PkgStartDate"></p>
    <p id="PkgEndDate"></p>
    <p id="PkgDesc"></p>
    <p id="PkgBasePrice"></p>
    <p id="PkgAgencyCommission"></p>
        <button class="btn-light" type="button" onclick="confirmDelete()">Delete</button>
</div><br /><br />
<h4 id="productsText"></h4>
<%--table to display products--%>
<table id="productsTable">
    <thead>
    </thead>
    <tbody>
    </tbody>
</table>
<script>
    //when the document loads the fetchPackages function is used
    $(document).ready(function(){
        fetchPackages();
    });
</script>
</div>
</body>
<%--adds view for footer--%>
<footer>
    <jsp:include page="footer.jsp" />
</footer>
</html>
