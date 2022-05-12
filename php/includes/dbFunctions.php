<?php
    require_once("php/includes/dbcon.php");

    //generate an sql statement for the given values and table
    function generateInsertString($tableName, $values)
    {
        $sql = "insert into $tableName ({fieldNames}) values ({values});";

        $fieldNames = array_keys($values);  //get keys from array
        $fieldValues = array_values($values);   //get values from array

        $str_fieldNames = '';
        $str_values = '';

        for ($i = 0; $i < count($fieldNames); $i++)
        {
            $sep = ',';
            if ($i === 0) $sep = '';

            $str_fieldNames .= $sep.$fieldNames[$i];    //add field name to the fieldnames string
            
            if (is_null($fieldValues[$i]))  //if value is null add 'NULL' to the values string
            {
                $str_values .= $sep.'NULL';
            }
            elseif (gettype($fieldValues[$i]) == "integer") //if value is an int add the value to the values string
            {
                $str_values .= $sep.(int)$fieldValues[$i];
            }
            elseif (gettype($fieldValues[$i]) == "double")  //if value is an double add the value to the values string
            {
                $str_values .= $sep.(double)$fieldValues[$i];
            }
            else    //if value is an string add the string to the values string with quotes
            {
                $str_values .= $sep."'".$fieldValues[$i]."'";
            }

        }
        //add field names and values to the sql statement
        $sql = str_replace('{fieldNames}', $str_fieldNames, $sql);
        $sql = str_replace('{values}', $str_values, $sql);


        return $sql;
        
    }

    //generate an sql statement for the given table, values and conditions
    function generateUpdateString($tableName, $values, $condition)
    {
        $sql = "update $tableName set {values} where $condition;";

        $fieldNames = array_keys($values);  //get keys from array
        $fieldValues = array_values($values);   //get values from array

        $str_values = '';

        for ($i = 0; $i < count($fieldNames); $i++)
        {
            $sep = ',';
            if ($i === 0) $sep = '';

            $str_values .= $sep.$fieldNames[$i].'=';    //add field name to the values string
            
            if (is_null($fieldValues[$i]))  //if value is null add 'NULL' to the values string
            {
                $str_values .= 'NULL';
            }
            elseif (gettype($fieldValues[$i]) == "integer") //if value is an int add the value to the values string
            {
                $str_values .= (int)$fieldValues[$i];
            }
            elseif (gettype($fieldValues[$i]) == "double")  //if value is an double add the value to the values string
            {
                $str_values .= (double)$fieldValues[$i];
            }
            else    //if value is an string add the string to the values string with quotes
            {
                $str_values .= "'".$fieldValues[$i]."'";
            }

        }
        //add field names and values to the sql statement
        $sql = str_replace('{values}', $str_values, $sql);

        echo $sql;

        return $sql;
        
    }

    function matchUserPassword($email, $pwd)
    {   
        global $con;
        $email = strtolower($email);
        $sql = "select user_id from users where email= '$email' and password= '$pwd'";
        $results = $con->query($sql);

        if ($results->num_rows < 1) return NULL;

        return $results->fetch_assoc()['user_id'];
    }

    function getBasicUserDetails($userId)
    {
        global $con;

        $sql = "select user_id, first_name, last_name, profile_photo, account_type from users where user_id = $userId";

        $results = $con->query($sql);

        if ($results->num_rows < 1) return NULL;

        return $results->fetch_assoc();
    }

    function addUser($values)   //todo profile photo
    {
        global $con;

        $sql = generateInsertString('users', $values);

        if($con->query($sql))
        {
            return $con->insert_id;
        }

        return NULL;
    }

    function doesEmailExist($email)
    {
        global $con;
        $email = strtolower($email);
        $sql = "select user_id from users where email = '$email'";
        $results = $con->query($sql);

        if ($results->num_rows < 1) return False;

        return True;
    }

    function addRequest($values, $userId)
    {
        global $con;

        $values['user_id'] = (int)$userId;

        $sql = generateInsertString('request', $values);

        if($con->query($sql))
        {
            return True;
        }

        return False;
    }

    function addSale($values, $userId)
    {
        global $con;

        $values['user_id'] = (int)$userId;

        $sql = generateInsertString('sale', $values);

        if($con->query($sql))
        {
            return True;
        }

        return False;
    }

   

    function getSale($id)   //get sale details from db
    {
        global $con;

        //get sale details
        $sql = "select * from sale where sale_id = $id";
        $results = $con->query($sql);

        //if sale doesnt exist
        if ($results and $results->num_rows < 1) return False;

        //fetch sale details
        $sale = $results->fetch_assoc();

        //get sale phone numbers
        $sql = "select phone from sale_phone where sale_id = $id";
        $results = $con->query($sql);
        $phone = array();
        $table = $results->fetch_all(MYSQLI_NUM);
        foreach ($table as $row)
        {
            $phone[] = $row[0];
        }
        $sale['phone'] = $phone;

        //get sale images
        $sql = "select media from sale_media where sale_id = $id";
        $results = $con->query($sql);
        $images = array();
        $table = $results->fetch_all(MYSQLI_NUM);
        foreach ($table as $row)
        {
            $images[] = $row[0];
        }
        $sale['images'] = $images;

        return $sale;
    }

    function getRequest($id)   //get sale details from db
    {
        global $con;

        //get request details
        $sql = "select * from request where request_id = $id";
        $results = $con->query($sql);

        //if request doesnt exist
        if ($results and $results->num_rows < 1) return False;

        //fetch request details
        $sale = $results->fetch_assoc();

        //get request phone numbers
        $sql = "select phone from request_phone where request_id = $id";
        $results = $con->query($sql);
        $phone = $results->fetch_array(MYSQLI_NUM);
        $sale['phone'] = $phone;

        return $sale;
    }

    function getSales($startFrom) //get list of sales from db
    {
        global $con;
        $sql = "select (sale_id, price, province, district, city, title, land_area) from sale limit $startFrom, 10";
        $results = $con->query($sql);

        if ($results and $results->num_rows < 1) return False;

        return $results->fetch_array(MYSQLI_ASSOC);
    }

    function getRequests($startFrom)  //get list of requests from db
    {
        global $con;
        $sql = "select (sale_id, max_price, min_price, province, district, city, title, max_area, min_area) from request limit $startFrom,10";
        $results = $con->query($sql);

        if ($results and $results->num_rows < 1) return False;

        return $results->fetch_array(MYSQLI_ASSOC);
    }

    function addSaleComplaint($values, $userId)
    {
        global $con;

        $values['user_id'] = (int)$userId;

        $sql = generateInsertString('sale_complaints', $values);

        if($con->query($sql))
        {
            return True;
        }

        return False;
    }

    function saveSale($values)
    {
        global $con;

        $action = $values['action'];
        unset($values['action']);

        switch ($action) {
            case 'save':
                $sql = generateInsertString('saved_sale', $values);
                break;

            case 'unsave':
                $sql = 'delete from saved_sale where user_id = ' . $values['user_id'] . ' and sale_id = ' . $values['sale_id'];
                break;

            default:
                return False;
        }

        if($con->query($sql)) //todo crashes on duplicate error
        {
            return True;
        }

        return True; //todo check error


    }

?>