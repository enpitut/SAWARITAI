<?php
ini_set('display_errors',1);

$rootNode = new SimpleXMLElement("<?xml version='1.0' encoding='UTF-8' standalone='yes'?><pois></pois>");
 
// ノードの追加
$itemNode = $rootNode->addChild('poi');
$itemNode->addChild( 'itemCode', 'mk' );
$itemNode->addChild( 'itemName', 'orange' );

$itemNode = $rootNode->addChild('poi');
$itemNode->addChild( 'itemCode', 'ap' );
$itemNode->addChild( 'itemName', 'apple' );
 
$itemNode = $rootNode->addChild('poi');
$itemNode->addChild( 'itemCode', 'tof' );
$itemNode->addChild( 'itemName', '豆腐' );
 
// ノードに属性を追加
$itemNode->addAttribute('stock', 'none');
 
// 作ったxmlツリーを出力する
echo $rootNode->asXML();