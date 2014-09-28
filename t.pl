#!/usr/bin/perl

use utf8;

use strict;
use DBI;

my $dbh = DBI->connect(          
    "dbi:mysql:dbname=wg", 
    "root",                          
    "root",                          
    { RaiseError => 1 },         
) or die $DBI::errstr;

$dbh->do("SET character_set_client = 'utf8'");
$dbh->do("SET character_set_connection = 'utf8'");
$dbh->do("SET character_set_results= 'utf8'");

my $sth = $dbh->prepare( "select count(*) as count, name from sys_goods group by name order by count" );  
$sth->execute();
      
my $i = 0;
while(my ($count, $name) = $sth->fetchrow())
{
  if($count > 1)
  {
    my $sql = "select id from sys_goods where name = '$name' order by id";
    #print "$sql\n";
    my $sth1 = $dbh->prepare($sql);
    $sth1->execute();
    my $j = 0;
    my $id0 = "";
    my $id1 = "";
    while(my ($id) = $sth1->fetchrow())
    {
      if($j == 0)
      {
        $id0 = $id;
      }
      if($j == 1)
      {
        $id1 = $id;
      }
      $j ++;
    }
    # print "$count $name: $id0, $id1\n";
    # print "update store_goods set goods_id = $id1 where goods_id = $id0;\n";
    # print "update store_goods set goods_id = $id0 where goods_id = $id1;\n";
    print "delete from sys_goods where id = $id0;\n";
    $i++;
  }
}

print "i = $i\n";
my $rows = $sth->rows();
print "We have selected $rows row(s)\n";

$sth->finish();
$dbh->disconnect();

