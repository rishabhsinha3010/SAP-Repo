using CatalogService as service from '../../srv/cat-service';

// ---------------------------------------------------------------
// Value helps
// ---------------------------------------------------------------
annotate service.PurchaseOrderSrv with {

    LSTEXT             @(Common: {
        Text     : LSTEXT,
        ValueList: {
            Label          : 'Life Cycle Status',
            CollectionPath : 'PurchaseOrderSrv',
            SearchSupported: true,
            Parameters     : [{
                $Type            : 'Common.ValueListParameterOut',
                LocalDataProperty: 'LSTEXT',
                ValueListProperty: 'LSTEXT'
            }]
        }
    });

    OSTEXT             @(Common: {
        Text     : OSTEXT,
        ValueList: {
            Label          : 'Overall Status',
            CollectionPath : 'PurchaseOrderSrv',
            SearchSupported: true,
            Parameters     : [{
                $Type            : 'Common.ValueListParameterOut',
                LocalDataProperty: 'OSTEXT',
                ValueListProperty: 'OSTEXT'
            }]
        }
    });

    PO_ID              @(Common: {
        Text     : PO_ID,
        ValueList: {
            Label          : 'Purchase Order ID',
            CollectionPath : 'PurchaseOrderSrv',
            SearchSupported: true,
            Parameters     : [{
                $Type            : 'Common.ValueListParameterOut',
                LocalDataProperty: 'PO_ID',
                ValueListProperty: 'PO_ID'
            }]
        }
    });

    partnerCountryDesc @(Common: {
        Text     : partnerCountryDesc,
        ValueList: {
            Label          : 'Country',
            CollectionPath : 'CountriesSrv',
            SearchSupported: true,
            Parameters     : [{
                $Type            : 'Common.ValueListParameterOut',
                LocalDataProperty: 'partnerCountryDesc',
                ValueListProperty: 'description'
            }]
        }
    });

    COMPANY_NAME       @(Common: {
        Text     : COMPANY_NAME,
        ValueList: {
            Label          : 'Company Name',
            CollectionPath : 'BusinessPatnerSrv',
            SearchSupported: true,
            Parameters     : [
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: 'BP_ID',
                    ValueListProperty: 'BP_ID'
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: 'COMPANY_NAME',
                    ValueListProperty: 'COMPANY_NAME'
                }
            ]
        }
    })
};

// ---------------------------------------------------------------
// Purchase Order: list report + object page
// ---------------------------------------------------------------
annotate service.PurchaseOrderSrv with @(
    UI.SelectionFields       : [
        PO_ID,
        COMPANY_NAME,
        LSTEXT,
        OSTEXT,
        partnerCountryDesc
    ],

    UI.LineItem              : [
        {
            $Type: 'UI.DataField',
            Value: PO_ID
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.discountPrice',
            Label : 'Discount',
            Inline: true
        },
        {
            $Type: 'UI.DataField',
            Value: COMPANY_NAME
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code
        },
        {
            $Type: 'UI.DataField',
            Value: CITY
        },

        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.EntityContainer/createPurchaseOrder',
            Label : 'Create',
            Inline: false
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.EntityContainer/updatePurchaseOrder',
            Label : 'Update',
            Inline: false
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.EntityContainer/deletePurchaseOrder',
            Label : 'Delete',
            Inline: false
        },

        {
            $Type      : 'UI.DataField',
            Value      : LSTEXT,
            Criticality: LSC
        },
        {
            $Type      : 'UI.DataField',
            Value      : OSTEXT,
            Criticality: OSC
        },
        {
            $Type: 'UI.DataField',
            Value: partnerCountryDesc
        }
    ],

    UI.HeaderInfo            : {
        TypeName      : 'Purchase Order',
        TypeNamePlural: 'Purchase Orders',
        Title         : {
            $Type: 'UI.DataField',
            Value: PO_ID
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: COMPANY_NAME
        },
        ImageUrl      : 'https://images.squarespace-cdn.com/content/v1/65a5d81bca27523f618feccf/68d9a6e3-ae27-4f3e-8c5e-f306ac36b8a3/Capgemini.png'
    },

    UI.HeaderFacets          : [{
        $Type : 'UI.CollectionFacet',
        Label : 'Business Partner Details',
        Facets: [
            {
                $Type : 'UI.ReferenceFacet',
                Label : 'General Information',
                Target: '@UI.FieldGroup#BPInfo'
            },
            {
                $Type : 'UI.ReferenceFacet',
                Label : 'Communication Information',
                Target: '@UI.FieldGroup#BPCommInfo'
            }
        ]
    }],

    UI.FieldGroup #BPInfo    : {Data: [
        {
            $Type: 'UI.DataField',
            Value: BP_ID
        },
        {
            $Type: 'UI.DataField',
            Value: COMPANY_NAME
        },
        {
            $Type: 'UI.DataField',
            Value: BP_ROLE
        }
    ]},

    UI.FieldGroup #BPCommInfo: {Data: [
        {
            $Type: 'UI.DataField',
            Value: EMAIL
        },
        {
            $Type: 'UI.DataField',
            Value: MOBILE
        },
        {
            $Type: 'UI.DataField',
            Value: FAX
        }
    ]},

    UI.Facets                : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Other details',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Amount Information',
                    Target: '@UI.FieldGroup#BPAmtInfo'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Address Information',
                    Target: '@UI.FieldGroup#BPAddrInfo'
                }
            ]
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Purchase Item Details',
            Target: 'Items/@UI.LineItem'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Item Amounts Chart',
            Target: 'Items/@UI.Chart'
        }
    ],

    UI.FieldGroup #BPAmtInfo : {Data: [
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code
        }
    ]},

    UI.FieldGroup #BPAddrInfo: {Data: [
        {
            $Type: 'UI.DataField',
            Value: STREET
        },
        {
            $Type: 'UI.DataField',
            Value: BUILDING
        },
        {
            $Type: 'UI.DataField',
            Value: CITY
        },
        {
            $Type: 'UI.DataField',
            Value: POSTAL_CODE
        },
        {
            $Type: 'UI.DataField',
            Value: COUNTRY
        }
    ]},
);

// ---------------------------------------------------------------
// Employee titles
// ---------------------------------------------------------------
annotate service.EmployeeSrv with {
    ID            @title: '{i18n>EMPLOYEE_ID}';
    nameFirst     @title: '{i18n>FIRST_NAME}';
    nameLast      @title: '{i18n>LAST_NAME}';
    email         @title: '{i18n>EMAIL}';
    accountNumber @title: '{i18n>ACCOUNT_NUMBER}';
    bankId        @title: '{i18n>BANK_ID}';
    bankName      @title: '{i18n>BANK_NAME}';
    language      @title: '{i18n>LANGUAGE}';
    gender        @title: '{i18n>GENDER}';
    loginName     @title: '{i18n>LOGIN_NAME}';
    CURRENCY_code @title: '{i18n>CURRENCY}';
};

// ---------------------------------------------------------------
// Purchase Item: analytics + chart (FIX for CURRENCY_CODE error)
// ---------------------------------------------------------------
annotate service.PurchaseItemSrv with {
    GROSS_AMOUNT @Analytics.Measure            : true
                 @Aggregation.default          : #SUM
                 @Semantics.amount.currencyCode: 'CURRENCY_code';
    NET_AMOUNT   @Analytics.Measure            : true
                 @Aggregation.default          : #SUM
                 @Semantics.amount.currencyCode: 'CURRENCY_code';
    TAX_AMOUNT   @Semantics.amount.currencyCode: 'CURRENCY_code';
};

annotate service.PurchaseItemSrv with @(
    Aggregation.ApplySupported               : {
        Transformations       : [
            'aggregate',
            'groupby',
            'filter',
            'identity',
            'concat',
            'search'
        ],
        GroupableProperties   : [
            PO_ITEM_POS,
            CURRENCY_code
        ],
        AggregatableProperties: [
            {Property: GROSS_AMOUNT},
            {Property: NET_AMOUNT}
        ]
    },
    Aggregation.CustomAggregate #GROSS_AMOUNT: 'Edm.Decimal',
    Aggregation.CustomAggregate #NET_AMOUNT  : 'Edm.Decimal',

    UI.Chart                                 : {
        Title              : 'Gross vs Net Amount per Item',
        ChartType          : #Column,
        Dimensions         : [PO_ITEM_POS],
        DimensionAttributes: [{
            $Type    : 'UI.ChartDimensionAttributeType',
            Dimension: PO_ITEM_POS,
            Role     : #Category
        }],
        Measures           : [
            GROSS_AMOUNT,
            NET_AMOUNT
        ],
        MeasureAttributes  : [
            {
                $Type  : 'UI.ChartMeasureAttributeType',
                Measure: GROSS_AMOUNT,
                Role   : #Axis1
            },
            {
                $Type  : 'UI.ChartMeasureAttributeType',
                Measure: NET_AMOUNT,
                Role   : #Axis1
            }
        ]
    }
);

// ---------------------------------------------------------------
// Purchase Item: object page / table
// ---------------------------------------------------------------
annotate service.PurchaseItemSrv with @(
    UI.SelectionFields            : [
        PO_ITEM_POS,
        PRODUCT.DESCRIPTION
    ],

    UI.LineItem                   : [
        {
            $Type: 'UI.DataField',
            Value: PO_ITEM_POS
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT_NODE_KEY
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.EntityContainer/createItem',
            Label : 'Create',
            Inline: false
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.EntityContainer/updateIteam',
            Label: 'Update',
            Inline: false
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.EntityContainer/deleteIteam',
            Label: 'Delete',
            Inline: false
        },

    ],

    UI.HeaderInfo                 : {
        TypeName      : 'Purchase Item',
        TypeNamePlural: 'Purchase Items',
        Title         : {
            $Type: 'UI.DataField',
            Value: PO_ITEM_POS
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: PRODUCT.DESCRIPTION
        },
        ImageUrl      : 'https://images.squarespace-cdn.com/content/v1/65a5d81bca27523f618feccf/68d9a6e3-ae27-4f3e-8c5e-f306ac36b8a3/Capgemini.png'
    },

    UI.Facets                     : [{
        $Type : 'UI.CollectionFacet',
        Label : 'Product Details',
        Facets: [
            {
                $Type : 'UI.ReferenceFacet',
                Label : 'Product Information',
                Target: '@UI.FieldGroup#ProductInfo'
            },
            {
                $Type : 'UI.ReferenceFacet',
                Label : 'Product Supplier Information',
                Target: '@UI.FieldGroup#ProductItemInfo'
            },
            {
                $Type : 'UI.ReferenceFacet',
                Label : 'options',
                Target : '@UI.FieldGroup#cruoptions'
            }
        ]
    }],

UI.FieldGroup #cruoptions : { Data: [
      {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.EntityContainer/createProductDetails',
            Label: 'create',
            Inline: false
     },
     {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.EntityContainer/',
            Label: 'Update',
            Inline: false
     },
     {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.EntityContainer/',
            Label: 'delete',
            Inline: false
     }
]},

    UI.FieldGroup #ProductInfo    : {Data: [
        {
            $Type: 'UI.DataField',
            Value: PRODUCT.DESCRIPTION
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT.DEPTH
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT.WIDTH
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT.HEIGHT
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT.PRICE
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT.CATEGORY
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT.MEASURE_UNIT
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT.CURRENCY_CODE
        }
    ]},

    UI.FieldGroup #ProductItemInfo: {Data: [
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT
        }
    ]},
);


