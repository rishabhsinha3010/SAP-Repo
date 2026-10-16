using {poapplication.db as database} from '../db/schema';
// using {Currency} from '@sap/cds/common';
using {poapplication.common as common} from '../db/common';

using {Currency} from '@sap/cds/common';

service CatalogService {
    //Master data which is in Master Context
    // @readonly @insertonly

    // @Capabilities : {
    //     InsertRestrictions.Insertable : true,
    //     UpdateRestrictions.Updatable : true,
    //     DeleteRestrictions.Deletable : true,
    //     ReadRestrictions.Readable : false
    // }
    entity EmployeeSrv       as
        projection on database.master.Employees {
            *
        }
        actions {
            action   increaseSalary()    returns array of EmployeeSrv;

            function Top20PaidEmployee() returns array of EmployeeSrv;
        }

    entity ProductSrv        as
        projection on database.master.Products {
            *
        }
        actions {
            action   increasePrice()  returns array of ProductSrv;

            function top_20_product() returns array of ProductSrv;
        }

    entity BusinessPatnerSrv as projection on database.master.BusinessPartners;

    entity AddressSrv        as projection on database.master.Addresses;
    entity CountriesSrv      as projection on database.Countries;
    // Transactional data which is in the Transaction context

    @Capabilities: {
        DeleteRestrictions: {
            $Type    : 'Capabilities.DeleteRestrictionsType',
            Deletable: false
        },
        UpdateRestrictions: {
            $Type    : 'Capabilities.UpdateRestrictionsType',
            Updatable: false
        },
        InsertRestrictions: {
            $Type     : 'Capabilities.InsertRestrictionsType',
            Insertable: false
        }
    }

    entity PurchaseOrderSrv  as
        select from database.transaction.PurchaseOrders as po

        inner join database.master.BusinessPartners as bp
            on bp.NODE_KEY = po.PARTNER.NODE_KEY

        inner join database.master.Addresses as addr
            on addr.NODE_KEY = bp.AD.NODE_KEY

        inner join database.Countries as country
            on addr.COUNTRY = country.code

        inner join database.BPRoleFltr as role
            on bp.BP_ROLE = role.code

        {
            key po.NODE_KEY,

                po.PO_ID,
                po.GROSS_AMOUNT,
                po.NET_AMOUNT,
                po.TAX_AMOUNT,
                po.CURRENCY,

                bp.COMPANY_NAME,
                bp.BP_ID,
                role.description    as BP_ROLE,
                bp.MOBILE,
                bp.FAX,
                bp.EMAIL,
                bp.WEB,

                addr.ADDRESS_TYPE,
                addr.BUILDING,
                addr.CITY,
                addr.COUNTRY,
                addr.LATITUDE,
                addr.LONGITUDE,
                addr.STREET,
                addr.POSTAL_CODE,

                po.Items,

                bp.COMPANY_NAME     as partnerName,
                bp.BP_ID            as partnerId,
                addr.COUNTRY        as partnerCountry,

                country.description as partnerCountryDesc @(title: '{i18n>COUNTRY}'),

                case
                    po.LIFECYCLE_STATUS
                    when 'N'
                         then 2
                    when 'S'
                         then 3
                    when 'C'
                         then 3
                    else 1
                end                 as LSC    : Integer,

                case
                    po.OVERALL_STATUS
                    when 'R'
                         then 1
                    when 'P'
                         then 3
                    when 'D'
                         then 3
                    else 2
                end                 as OSC    : Integer,

                case
                    po.LIFECYCLE_STATUS
                    when 'N'
                         then 'Not Started'
                    when 'S'
                         then 'Started'
                    when 'C'
                         then 'Completed'
                    else 'Cancelled'
                end                 as LSTEXT : String(20)
                                                          @(title: '{i18n>LIFECYCLE_STATUS}'),

                case
                    po.OVERALL_STATUS
                    when 'R'
                         then 'Returned'
                    when 'P'
                         then 'Processed'
                    when 'D'
                         then 'Delivered'
                    else 'New'
                end                 as OSTEXT : String(20)
                                                          @(title: '{i18n>OVERALL_STATUS}')
        }

        actions {

            // Declare instance bounded action
            action   discountPrice() returns array of PurchaseOrderSrv;

            // Declare instance bounded function
            function largestOrder()  returns array of PurchaseOrderSrv;
        };

    entity PurchaseItemSrv   as projection on database.transaction.PurchaseItems;

    // Declaration of an action
    action   createEmployee(Currency_code: String(3)        @title: '{i18n>CURRENCY}',
                            ID: UUID                        @title: '{i18n>EMPLOYEE_ID}',
                            accountNumber: common.String32  @title: '{i18n>ACCOUNT NUMBER}',
                            bankId: String(16)              @title: '{i18n>BANK_ID}',
                            bankName: common.String64       @title: '{i18n>BANK NAME}',
                            email: common.Email             @title: '{i18n>EMAIL}',
                            gender: common.Gender           @title: '{i18n>GENDER}',
                            language: String(2)             @title: '{i18n>LANGUAGE}',
                            loginName: String(16)           @title: '{i18n>LOGIN_NAME}',
                            nameFirst: common.String64      @title: '{i18n>FIRST_NAME}',
                            nameInitials: common.String64   @title: '{i18n>NAME INITIALS}',
                            nameLast: common.String64       @title: '{i18n>LAST_NAME}',
                            nameMiddle: common.String64     @title: '{i18n>NAME_MIDDLE}',
                            phoneNumber: common.PhoneNumber @title: '{i18n>PHONE_NUMBER}',
                            salaryAmount: common.AmountT    @title: '{i18n>SALARY_AMOUNT}' )                                            returns array of EmployeeSrv;

    action   createAddressSrv(NODE_KEY: UUID,
                              ADDRESS_TYPE: common.String32,
                              VAL_START: Date,
                              VAL_END: Date,
                              LATITUDE: Decimal(9, 6),
                              LONGITUDE: Decimal(9, 6),
                              STREET: common.String255,
                              POSTAL_CODE: common.String32,
                              CITY: common.String255,
                              COUNTRY: common.String255,
                              BUILDING: common.String255)                                                                               returns array of AddressSrv;

    action   updateEmployee(ID: UUID,
                            salaryAmount: common.AmountT,
                            Currency_code: String(3))                                                                                   returns String;

    action   updateAddress(NODE_KEY: UUID,
                           CITY: common.String255, )                                                                                    returns String;

    action   createProduct(NODE_KEY: common.Guid,
                           PRODUCT_ID: common.String32,
                           TYPE_CODE: String(2),
                           CATEGORY: common.String32,
                           DESCRIPTION: common.String255,
                           TAX_TARIF_CODE: Integer,
                           MEASURE_UNIT: String(2),
                           WEIGHT_MEASURE: Decimal(5, 2),
                           WEIGHT_UNIT: String(2),
                           PRICE: Decimal(15, 2),
                           CURRENCY_CODE: String(5),
                           WIDTH: Decimal(5, 2),
                           DEPTH: Decimal(5, 2),
                           HEIGHT: Decimal(5, 2),
                           DIM_UNIT: String(2))                                                                                         returns array of ProductSrv;

    action   createPurchaseOrder(NODE_KEY: common.Guid        @(title: '{i18n>NODE_KEY}'),
                                 PO_ID: common.Guid           @(title: '{i18n>PO_ID}'),
                                 // Managed Association
                                 LIFECYCLE_STATUS: String(1)  @(title: '{i18n>LIFECYCLE_STATUS}'),
                                 OVERALL_STATUS: String(1)    @(title: '{i18n>OVERALL_STATUS}'),
                                 GROSS_AMOUNT: common.AmountT @(title: '{i18n>GROSS_AMOUNT}'),
                                 NET_AMOUNT: common.AmountT   @(title: '{i18n>NET_AMOUNT}'),
                                 TAX_AMOUNT: common.AmountT   @(title: '{i18n>TAX_AMOUNT}')
    )                                                                                                                                   returns array of PurchaseOrderSrv;

    action   updatePurchaseOrder(NODE_KEY: common.Guid,
                                 LIFECYCLE_STATUS: String(1),
                                 NET_AMOUNT: common.AmountT,
                                 TAX_AMOUNT: common.AmountT)                                                                            returns array of String;

    action   deletePurchaseOrder(NODE_KEY: common.Guid)                                                                                 returns array of String;

    action   createItem(NODE_KEY: common.Guid        @(title: '{i18n>NODE_KEY}'),
                        // Parent Purchase Order
                        PO_ITEM_POS: Integer         @(title: '{i18n>PO_ITEM_POS}'),
                        GROSS_AMOUNT: common.AmountT @(title: '{i18n>GROSS_AMOUNT}'),
                        NET_AMOUNT: common.AmountT   @(title: '{i18n>NET_AMOUNT}'),
                        TAX_AMOUNT: common.AmountT   @(title: '{i18n>TAX_AMOUNT}')
    )                                                                                                                                   returns array of PurchaseItemSrv;

    action   updateIteam(NODE_KEY: common.Guid @(title: '{i18n>NODE_KEY}'), NET_AMOUNT: common.AmountT @(title: '{i18n>NET_AMOUNT}'), ) returns String;

    action   deleteIteam(NODE_KEY: common.Guid @(title: '{i18n>NODE_KEY}') )                                                            returns String;

    action   createProductDetails(NODE_KEY: common.Guid         @(title: '{i18n>NODE_KEY}'),
                                  PRODUCT_ID: common.String32   @(title: '{i18n>PRODUCT_ID}'),
                                  CATEGORY: common.String32     @(title: '{i18n>CATEGORY}'),
                                  DESCRIPTION: common.String255 @(title: '{i18n>DESCRIPTION}'),
                                  TAX_TARIF_CODE: Integer       @(title: '{i18n>TAX_TARIF_CODE}'),
                                  MEASURE_UNIT: String(2)       @(title: '{i18n>MEASURE_UNIT}'),
                                  WEIGHT_MEASURE: Decimal(5, 2) @(title: '{i18n>WEIGHT_MEASURE}'),
                                  WEIGHT_UNIT: String(2)        @(title: '{i18n>WEIGHT_UNIT}'),
                                  PRICE: Decimal(15, 2)         @(title: '{i18n>PRICE}'),
                                  CURRENCY_CODE: String(5)      @(title: '{i18n>CURRENCY_CODE}'),
                                  WIDTH: Decimal(5, 2)          @(title: '{i18n>WIDTH}'),
                                  DEPTH: Decimal(5, 2)          @(title: '{i18n>DEPTH}'),
                                  HEIGHT: Decimal(5, 2)         @(title: '{i18n>HEIGHT}'),
                                  DIM_UNIT: String(2)           @(title: '{i18n>DIM_UNIT}',

    ) )                                                                                                                                 returns array of PurchaseItemSrv;

    action   updateProductPrice(NODE_KEY: common.Guid,
                                PRICE: Decimal(15, 2))                                                                                  returns String;

    action   deleteEmployee(ID: UUID)                                                                                                   returns String;

    function getHighestSalariedEmployees()                                                                                              returns array of EmployeeSrv;

    // Custom Function Declaration
    function getHeighestPricedProduct()                                                                                                 returns array of ProductSrv;

    function getUtilities()                                                                                                             returns String;
}
