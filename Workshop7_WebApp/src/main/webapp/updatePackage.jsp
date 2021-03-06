<%--
  Created by IntelliJ IDEA.
  User: allan
  Date: 2022-04-20
  Time: 10:14 a.m.
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<%--adds view for header--%>
<header>
    <jsp:include page="header.jsp" />
</header>
<head>
    <link href="stylesheet.css" rel="stylesheet" />
    <title>Update Package</title>
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

            //date formatter
            var startdate = dayjs(packageJSON.pkgStartDate).format("YYYY-MM-DD");
            var enddate = dayjs(packageJSON.pkgEndDate).format("YYYY-MM-DD");
            //format amount
            var basePrice = (packageJSON.pkgBasePrice).toFixed(2);
            var commission = (packageJSON.pkgAgencyCommission).toFixed(2);

            //adds text for each element of the package
            $("#PackageId").val(packageJSON.packageId);
            $("#PkgName").val(packageJSON.pkgName);
            $("#PkgStartDate").val(startdate);
            $("#PkgEndDate").val(enddate);
            $("#PkgDesc").val(packageJSON.pkgDesc);
            $("#PkgBasePrice").val(basePrice);
            $("#PkgAgencyCommission").val(commission);

        }

        //function to add a specific package to db
        async function updatePackage() {
            // format startdate and enddate
            var startdate = dayjs($("#PkgStartDate").val()).format("YYYY-MM-DD");
            var enddate = dayjs($("#PkgEndDate").val()).format("YYYY-MM-DD");

            //get the values of base price and commission
            var baseprice = $("#PkgBasePrice").val();
            var commission = $("#PkgAgencyCommission").val();

            //sets the textfields as visible or not based on validation
            if($("#PkgName").val().length > 50 || $("#PkgName").val().length == 0)
            {
                $("#lblPkgName").show();
            }
            else
            {
                $("#lblPkgName").hide();
            }

            if(startdate > enddate || startdate < Date.now() || $("#PkgStartDate").val() == "")
            {
                $("#lblPkgStartDate").show();
            }
            else
            {
                $("#lblPkgStartDate").hide();
            }

            if(startdate > enddate || enddate < Date.now() || $("#PkgEndDate").val() == "")
            {
                $("#lblPkgEndDate").show();
            }
            else
            {
                $("#lblPkgEndDate").hide();
            }

            if($("#PkgDesc").val().length > 50 || $("#PkgDesc").val().length == 0)
            {
                $("#lblPkgDesc").show();
            }
            else
            {
                $("#lblPkgDesc").hide();
            }

            if(baseprice <= commission || baseprice.length == 0)
            {
                $("#lblPkgBasePrice").show();
            }
            else
            {
                $("#lblPkgBasePrice").hide();
            }

            if(baseprice <= commission || commission.length == 0)
            {
                $("#lblPkgAgencyCommission").show();
            }
            else
            {
                $("#lblPkgAgencyCommission").hide();
            }


            //this function is to set the textfields is validated true or false
            var isPkgName = $("#PkgName").val().length > 50 || $("#PkgName").val().length == 0 ? false : true;
            var isPkgStartDate = startdate > enddate || startdate < Date.now() || $("#PkgStartDate").val() == "" ? false : true;
            var isPkgEndDate = startdate > enddate || enddate < Date.now() || $("#PkgEndDate").val() == "" ? false : true;
            var isPkgDesc = $("#PkgDesc").val().length > 50 || $("#PkgDesc").val().length == 0 ? false : true;
            var isPkgBasePrice = baseprice <= commission || baseprice.length == 0 ? false : true;
            var isPkgAgencyCommission = baseprice <= commission || commission.length == 0 ? false : true;

            //check if all textfields is validated, if false the alert message will show
            if(isPkgName == false
                || isPkgStartDate == false
                || isPkgEndDate == false
                || isPkgDesc == false
                || isPkgBasePrice == false
                || isPkgAgencyCommission == false
            )
            {
                //this is the alert message if validated false
                alert("Please check the validated textfields.");
            }
            else //if the textfields is validated true
            {
                //create json object for package details
                const putData = {
                    "packageId":$("#PackageId").val(),
                    "pkgName":$("#PkgName").val(),
                    "pkgStartDate":startdate,
                    "pkgEndDate":enddate,
                    "pkgDesc":$("#PkgDesc").val(),
                    "pkgBasePrice":$("#PkgBasePrice").val(),
                    "pkgAgencyCommission":$("#PkgAgencyCommission").val()
                };

                //url for update packages from REST app
                var url = "http://localhost:8080/api/updatepackage" ;
                try {
                    const response = await fetch(url,
                        {
                            method: "POST",
                            headers: {"Content-type": "application/json"},
                            body: JSON.stringify(putData)
                        });

                    // check if the response is success or not
                    if (!response.ok) {
                        // failed message
                        const message = "Insert failed: status=" + response.status;
                        throw new Error(message);
                    }
                    else
                    {
                        // success message
                        alert("Successfully updated Package.");
                        // set the textfields as empty
                        $("#PkgName").val("");
                        $("#PkgStartDate").val("");
                        $("#PkgEndDate").val("");
                        $("#PkgDesc").val("");
                        $("#PkgBasePrice").val("");
                        $("#PkgAgencyCommission").val("");
                        location.reload();
                    }
                } catch (e) {
                    console.log("Error: " + e); //error logs
                }
            }
        }

    </script>
</head>

<body  id="bckgrnd">
<div id="pckgForm">
<h1><%= "Modify Your Package" %>
</h1>
<%--package selection option, Initiates fetchPackage and fetchProducts when selection is made--%>
<select id="packageselect" onchange="fetchPackage(this.value)">
    <option value="">Select a package to view details</option>
</select><br /><br />
<%--form for the package details fields--%>
<form>
    <label for="PackageId" class="form-label">Package Id:</label>
    <input id="PackageId" type="number" disabled="disabled" class="form-control"/><br />
    <label for="PkgName" class="form-label">Package Name:</label>
    <input id="PkgName" type="text" class="form-control"/><label id="lblPkgName" style="color: red;padding-left: 10px;">0 or >50 characters is not allowed.</label><br />
    <label for="PkgStartDate" class="form-label">Start Date:</label>
    <input id="PkgStartDate" type="date" class="form-control"/>
    <label id="lblPkgStartDate" style="color: red;padding-left: 10px;">The start date is required & must be less than end date.</label><br />
    <label for="PkgEndDate" class="form-label">End Date:</label>
    <input id="PkgEndDate" type="date" class="form-control"/><label id="lblPkgEndDate" style="color: red;padding-left: 10px;">The end date is required & must be greater than start date.</label><br />
    <label for="PkgDesc" class="form-label">Description:</label>
    <input id="PkgDesc" type="text" class="form-control"/><label id="lblPkgDesc" style="color: red;padding-left: 10px;">0 or >50 characters is not allowed.</label><br />
    <label for="PkgBasePrice" class="form-label">Base Price:</label>
    <input id="PkgBasePrice" type="number" step=".01" class="form-control"/><label id="lblPkgBasePrice" style="color: red;padding-left: 10px;">Enter positive number value and base price must be greater than commission.</label><br />
    <label for="PkgAgencyCommission" class="form-label">Commission:</label>
    <input id="PkgAgencyCommission" type="number" step=".01" class="form-control"/><label id="lblPkgAgencyCommission" style="color: red;padding-left: 10px;">Enter positive number value and commission must be less than base price.</label><br />

    <button class="btn-light" type="button" onclick="updatePackage()">Update</button>
</form>
<script>
    //when the document loads the fetchPackages function is used
    $(document).ready(function(){
        fetchPackages();

        //sets all alert labels is hide
        $("#lblPkgName").hide();
        $("#lblPkgStartDate").hide();
        $("#lblPkgEndDate").hide();
        $("#lblPkgDesc").hide();
        $("#lblPkgBasePrice").hide();
        $("#lblPkgAgencyCommission").hide();
    });
</script>
</div>
</body>
<footer>
    <jsp:include page="footer.jsp" />
</footer>
</html>
