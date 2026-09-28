using {poapplication.db as database} from '../db/schema';
// using {Currency} from '@sap/cds/common';
using {poapplication.common as common} from '../db/common';

service CatalogService {
    //Master data which is in Master Context
    // @readonly @insertonly

    // @Capabilities : { 
    //     InsertRestrictions.Insertable : true,
    //     UpdateRestrictions.Updatable : true,
    //     DeleteRestrictions.Deletable : true,
    //     ReadRestrictions.Readable : false
    // }
    entity EmployeeSrv as projection on database.master.Employees{
        *
    }actions{
        action increaseSalary() returns array of EmployeeSrv;

        function Top20PaidEmployee() returns array of EmployeeSrv;
    }

    entity ProductSrv as projection on database.master.Products{
        *
    }actions{
        action increasePrice() returns array of ProductSrv;

        function top_20_product() returns array of ProductSrv;
    }

    entity BusinessPatnerSrv as projection on database.master.BusinessPartners;

    entity AddressSrv as projection on database.master.Addresses;

    // Transactional data which is in the Transaction context
    entity PurchaseOrderSrv as projection on database.transaction.PurchaseOrders{
        *
    } actions {
        //Declare instance bounded action
        action discountPrice() returns array of PurchaseOrderSrv;

        function largestOrder() returns array of PurchaseOrderSrv;
    };

    entity PurchaseItemSrv as projection on database.transaction.PurchaseItems;

    // Declaration of an action
    action createEmployee(
        Currency_code   : String(3),
        ID              : UUID,
        accountNumber   : common.String32,
        bankId          : String(16),
        bankName        : common.String64,
        email           : common.Email,
        gender          : common.Gender,
        language        : String(2),
        loginName       : String(16),
        nameFirst       : common.String64,
        nameInitials    : common.String64,
        nameLast        : common.String64,
        nameMiddle      : common.String64,
        phoneNumber     : common.PhoneNumber,
        salaryAmount    : common.AmountT
    ) returns array of EmployeeSrv;

    action createAddressSrv( NODE_KEY : UUID,
                            ADDRESS_TYPE : common.String32,
                            VAL_START    : Date,
                            VAL_END      : Date,
                            LATITUDE     : Decimal(9,6),
                            LONGITUDE    : Decimal(9,6),
                            STREET      : common.String255,
                            POSTAL_CODE : common.String32,
                            CITY        : common.String255,
                            COUNTRY     : common.String255,
                            BUILDING    : common.String255) returns array of AddressSrv;

    action updateEmployee(
        ID: UUID,
        salaryAmount: common.AmountT,
        Currency_code: String(3)
    ) returns String;

    action updateAddress(
        NODE_KEY: UUID,
        CITY : common.String255,
    ) returns String;

    action createProduct(
    NODE_KEY        : common.Guid,
    PRODUCT_ID      : common.String32,
    TYPE_CODE       : String(2),
    CATEGORY        : common.String32,
    DESCRIPTION     : common.String255,
    TAX_TARIF_CODE  : Integer,
    MEASURE_UNIT    : String(2),
    WEIGHT_MEASURE  : Decimal(5,2),
    WEIGHT_UNIT     : String(2),
    PRICE           : Decimal(15,2),
    CURRENCY_CODE   : String(5),
    WIDTH           : Decimal(5,2),
    DEPTH           : Decimal(5,2),
    HEIGHT          : Decimal(5,2),
    DIM_UNIT        : String(2) ) returns array of ProductSrv;

    action updateProductPrice(
        NODE_KEY : common.Guid,
        PRICE    : Decimal(15,2)
    ) returns String;

    action deleteEmployee(
        ID: UUID
    ) returns String;

    function getHighestSalariedEmployees() returns array of EmployeeSrv;

    // Custom Function Declaration
    function getHeighestPricedProduct() returns array of ProductSrv;

    function getUtilities() returns String;
}

