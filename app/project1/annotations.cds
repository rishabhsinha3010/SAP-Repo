using CatalogService as service from '../../srv/cat-service';

annotate service.PurchaseOrderSrv with @(
    UI.SelectionFields       : [
        PO_ID,
        COMPANY_NAME,
        GROSS_AMOUNT,
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
        // {
        //     $Type :'UI.DataFieldForAction',
        //     Action: 'CatalogService.EntityContainer/createEmployee',
        //     Label : 'Create Employee'
        // },
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

    //

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
        ],

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

    // inline facets for address information
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
        }
    ],

    // inline facets for address information
    // UI.Facets  : [
    //             {
    //                 $Type : 'UI.ReferenceFacet',
    //                 Label : 'Amount Information',
    //                 Target : '@UI.FieldGroup#BPAmtInfo'
    //             },
    //             {
    //                 $Type : 'UI.ReferenceFacet',
    //                 Label : 'Address Information',
    //                 Target : '@UI.FieldGroup#BPAddrInfo'
    //             },
    // ],


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

annotate service.PurchaseItemSrv with @(
    UI.SelectionFields: [
        PO_ITEM_POS,
        PRODUCT_NODE_KEY
    ],

    UI.LineItem       : [
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
        }
    ]
);
