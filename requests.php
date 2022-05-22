<?php
    session_start();
    require_once('php\controllers\requests-ctrl.php');
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Home</title>
    <link rel="stylesheet" href="styles\index.css">
    <link rel="stylesheet" href="styles\page-container.css">    

    <?php include_once('php/includes/common-css-js.php'); ?>
</head>
<body>
    <?php
        include("php/templates/header.php");
    ?>

    <!--body-->
    <form class="search-form" action="requests.php">
        <input type="search" name="search" id="search">
        <input type="submit" value="Search">
    </form>

    <div class="container">

        <?php if (isset($results)) : ?>
            <div class="first">
                <h3>Results</h3>
                <div class="card-container">
                    <?php 
                        if ($results)
                        {
                            foreach ($results as $cardData)
                            {
                                include('php\templates\request-card.php');
                            }
                        }
                        else
                        {
                            echo "<h2>No results found</h2>";
                        }
                    ?>
                </div>
            </div>
        <?php else : ?>
            <div class="first">
                <h3>Top-Requests</h3>
                <div class="card-container">
                    <?php 
                        if ($topPosts)
                        {
                            foreach ($topPosts as $cardData)
                            {
                                include('php\templates\request-card.php');
                            }
                        }
                        else
                        {
                            echo "<h2>No results found</h2>";
                        }
                    ?>
                </div>
            </div>
            <div class="second">
                <h3>Requests</h3>
                <div class="card-container">
                    <?php 
                        if ($posts)
                        {
                            foreach ($posts as $cardData)
                            {
                                include('php\templates\request-card.php');
                            }
                        }
                        else
                        {
                            echo "<h2>No results found</h2>";
                        }
                    ?>
                </div>
            </div>
        <?php endif; ?>

        <div class="btn-container-ralign">
            <?php
                $uri =  $_SERVER['REQUEST_URI'];
                if (preg_match("/page=/", $uri))
                {
                    $page = (int)$_GET['page'];
                    if ($page > 1)
                    {
                        echo "<input type='button' class='page-btn' value='Prev Page' onclick=\"window.location.href = '".preg_replace("/page=\d+/", 'page='.$page - 1, $uri)."' \">";
                    }
                    echo "<input type='button' class='page-btn' value='Next Page' onclick=\"window.location.href = '".preg_replace("/page=\d+/", 'page='.$page + 1, $uri)."' \">";
                }
                else{
                    echo "<input type='button' class='page-btn' value='Next Page' onclick=\"window.location.href = '".preg_replace("/php.?/",'php?page=2&', $uri)."' \">";
                    
                }
            ?>
        </div>
    </div>

    <?php
        include("php/templates/footer.php");
    ?>
</body>
</html>