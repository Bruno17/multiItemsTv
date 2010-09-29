<?php
/**
 * @package modx
 * @subpackage processors.element.tv.renders.mgr.input
 */
$this->xpdo->lexicon->load('tv_widget');

//$items = $this->xpdo->fromJSON($this->get('value')); 

$options = $this->parseInputOptions($this->processBindings($this->get('elements'),$this->get('name')));

//print_r($options);
//print_r($this->xpdo->toJSON($options));//['name','description','price1','pricetext1','price2','pricetext2']	

if (count($options)>0){
	foreach($options as $option){
	    $option=explode(':',$option);
		    $fieldnames[]=$option[0];
			$captions[]=!empty($option[1])?$option[1]:$option[0];
	}
	$fieldnames=$this->xpdo->toJSON($fieldnames);
	$captions=$this->xpdo->toJSON($captions);
}

// handles image fields using htmlarea image manager
$this->xpdo->smarty->assign('base_url',$this->xpdo->getOption('base_url'));
$this->xpdo->smarty->assign('fieldnames',$fieldnames);
$this->xpdo->smarty->assign('captions',$captions);

return $this->xpdo->smarty->fetch('element/tv/renders/input/multiitems.tpl');