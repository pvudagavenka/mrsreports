/*global QUnit*/                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                               
sap.ui.define([                                                                                                                                                                                                                                                
	"ZINFRA_MRS_PLANNING_BOARD/ZINFRA_MRS_PLANNING_BOARD/controller/SelectionView.controller"                                                                                                                                                                     
], function (Controller) {                                                                                                                                                                                                                                     
	"use strict";                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                               
	QUnit.module("SelectionView Controller");                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                               
	QUnit.test("I should test the SelectionView controller", function (assert) {                                                                                                                                                                                  
		var oAppController = new Controller();                                                                                                                                                                                                                       
		oAppController.onInit();                                                                                                                                                                                                                                     
		assert.ok(oAppController);                                                                                                                                                                                                                                   
	});                                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                               
});                                                                                                                                                                                                                                                            