sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"project1/test/integration/pages/PurchaseOrderSrvList.gen",
	"project1/test/integration/pages/PurchaseOrderSrvObjectPage.gen",
	"project1/test/integration/pages/PurchaseItemSrvObjectPage.gen"
], function (JourneyRunner, PurchaseOrderSrvListGenerated, PurchaseOrderSrvObjectPageGenerated, PurchaseItemSrvObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('project1') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseOrderSrvListGenerated: PurchaseOrderSrvListGenerated,
			onThePurchaseOrderSrvObjectPageGenerated: PurchaseOrderSrvObjectPageGenerated,
			onThePurchaseItemSrvObjectPageGenerated: PurchaseItemSrvObjectPageGenerated
        },
        async: true
    });

    return runner;
});

