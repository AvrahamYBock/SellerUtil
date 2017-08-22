<?php
    include "utils/Database.php";
    try{
        $db=Database::getDb();
        $query = "SELECT sp.sku, sd.description, cogs.price
                    FROM `skus_primary` sp
                    LEFT JOIN sku_description sd
                    ON sp.sku = sd.sku
                    LEFT JOIN cogs
                    ON sp.sku = cogs.sku
                    GROUP BY sp.sku";
        $results = $db->query($query);
        $skusPrices = $results->fetchAll(PDO::FETCH_NUM);
    }catch (PDOException $e) {
        $errors = "Something went wrong " . $e->getMessage();
    }
?>