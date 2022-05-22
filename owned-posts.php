<?php session_start(); ?>
<html>
<head>
    <title>Owned-Posts</title>
    <link rel="stylesheet" href="styles/reqownForm.css">
</head>
<body style="background:linear-gradient(135deg, #71b7e6, #9b59b6);">

<?php
require 'php/includes/dbcon.php';
echo "<h2 class=\"ownTitle\">Owned Request Post</h2>";
$userId=$_GET['id'];
$userId=$_SESSION['user_id'];
$sql="SELECT * FROM request where user_id='$userId'";
$result=$con->query($sql);

if($result=$con->query($sql)){
    if($result->num_rows>0){
        //read form-data
        while($row=$result->fetch_assoc()){
            //read and utilize form-data
             $img=$row['cover_photo'];
             if($row['max_price']==-1)
             {
                 $row['max_price']="Not Negotiable";
             }
             if($row['max_price']==NULL)
             {
                 $row['max_price']="Negotiable";
             }
             $id=$row['request_id'];
             echo "<div id=\"ownedCard\">";
             echo "<img src=\"$img\" alt=\"Picture of a land\" height=\"150\" width=\"150\" id=\"ownedImg\">";
             echo "<h2>".$row['title']."</h2>";
             echo "<p>".$row['description']."</p>";
             echo "<br>";
             echo "<br>";
             echo "<br>";
             echo "<button class=\"ownBtn\">"."<a href=\"\">"."View"."</a>"."</button>";  
             echo "<button class=\"ownBtn\">"."<a href=\"edit-request-form.php?id=$id\">"."Edit"."</a>"."</button>";    
             echo "<button class=\"ownBtn\">"."<a href=\"php/includes/delete_req.php?id=$id\">"."Delete"."</a>"."</button>";
             echo "<span id=\"ownedPrice\">". $row['max_price'] . "</span>";
             echo "</div>";
        }
    } else {
        echo "<b>No results</b>";
    }
}

echo "<h2 class=\"ownTitle\">Owned Sale Post</h2>";
$sql="SELECT * FROM sale where user_id=$userId";
$result=$con->query($sql);

if($result=$con->query($sql)){
    if($result->num_rows>0){
        //read form-data
        while($row=$result->fetch_assoc()){
            //read and utilize form-data
             $img=$row['cover_photo'];
             if($row['price']==-1)
             {
                 $row['price']="Not Negotiable";
             }
             if($row['price']==NULL)
             {
                 $row['price']="Negotiable";
             }
             $id=$row['sale_id'];
             echo "<div id=\"ownedCard\">";
             echo "<img src=\"$img\" alt=\"Picture of a land\" height=\"150\" width=\"150\" id=\"ownedImg\">";
             echo "<h2>".$row['title']."</h2>";
             echo "<p>".$row['description']."</p>";
             echo "<br>";
             echo "<br>";
             echo "<br>";
             echo "<button class=\"ownBtn\">"."<a href=\"\">"."View"."</a>"."</button>";  
             echo "<button class=\"ownBtn\">"."<a href=\"edit-sale-form.php?id=$id\">"."Edit"."</a>"."</button>";    
             echo "<button class=\"ownBtn\">"."<a href=\"php/includes/delete_sale.php?id=$id\">"."Delete"."</a>"."</button>";
             echo "<span id=\"ownedPrice\">". $row['price'] . "</span>";
             echo "</div>";
        }
    } else {
        echo "No results";
    }
}

?>


</body>
</html>
