<?php
    class Database{
        private $cs;
        private $user;
        private $password;
        private $options;
        private $db;
        private function __construct(){
        }
        public static function getDb(){
            if (!isset($getDb)){
                $database = new Database();
                $cs = "mysql:host=localhost;dbname=amazon";
                $user = "test";
                $password = 'password';
                $options = [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION];
                try {
                    $db = new PDO($cs, $user, $password, $options);
                } catch (PDOException $e) {
                    $error = "Something went wrong " . $e->getMessage();
                }
        }
            return $db;
        }
    }
?>