const { transaction, resolve, error, tx } = require("@sap/cds");
const { INSERT } = require("@sap/cds/lib/ql/cds-ql");
const { uuid, exists, isdir, read, mkdir, } = cds.utils;

module.exports = cds.service.impl(async function () {
    // Step 1. Declare Employee Service from Entities
    const { EmployeeSrv } = this.entities;
    const { AddressSrv } = this.entities;
    const { ProductSrv, PurchaseOrderSrv } = this.entities;

    // Implementation of an action
    // There are 3 geenric handlers
    // .before() : Pre-check and validation
    // .on() : Performing DB operations
    // .after() : To save / close connections

    // createEmployee from cat-service.cds
    this.on('createEmployee', async (request, response) => {
        // Step-2 : Get the data which is coming from the API
        const empData = request.data;

        //step-3 : Instantiate the transaction object
        const objTransaction = cds.tx(request);

        //step-4 : Insert the record into database
        let returnData = await objTransaction.run([
            INSERT.into(EmployeeSrv).entries(empData)
        ]).then((resolve, reject) => {
            if (typeof (resolve) !== undefined) {
                return request.data
            } else {
                request.error(500, "Error in inserting data into the database")
            }
        }).catch(err => {
            request.error("There is an error : ", err.toString())
        })

        //step-5 : Return the data
        return returnData;
    });

    this.on('createAddressSrv', async (request, response) => {
        // Step-2 : Get the data which is coming from the API
        const addressData = request.data;

        //step-3 : Instantiate the transaction object
        const objTransaction = cds.tx(request);

        //step-4 : Insert the record into database
        let returnData = await objTransaction.run([
            INSERT.into(AddressSrv).entries(addressData)
        ]).then((resolve, reject) => {
            if (typeof (resolve) !== undefined) {
                return request.data
            } else {
                request.error(500, "Error in inserting address data into the database")
            }
        }).catch(err => {
            request.error("There is an error : ", err.toString());
        });

        //step-5 : Return the data
        return returnData;
    })

    this.on('createProduct', async (request, response) => {

        const productData = request.data;

        const objTransaction = cds.tx(request);

        let returnData = await objTransaction.run([
            INSERT.into(ProductSrv).entries(productData)
        ]).then((resolve, reject) => {

            if (typeof (resolve) !== 'undefined') {
                return request.data;
            } else {
                request.error(500, "Error in inserting product data");
            }

        }).catch(err => {
            request.error(500, "There is an error: " + err.toString());
        });

        return returnData;
    });

    this.on('updateEmployee', async (request, response) => {
        const {
            ID,
            salaryAmount,
            Currency_code
        } = request.data;

        try {
            const objTansaction = cds.tx(request);

            await objTansaction.update(EmployeeSrv).with({
                salaryAmount: salaryAmount,
                Currency_code: Currency_code
            }).where({
                ID: ID
            })

            return "Successfully update.";
        } catch (error) {
            request.error("Error : ", error)
        }
    })



    this.on('updateAddress', async (request, response) => {
        const {
            NODE_KEY,
            CITY
        } = request.data;

        try {
            const objTansaction = cds.tx(request);
            await objTansaction.update(AddressSrv).with({
                CITY: CITY
            }).where({
                NODE_KEY: NODE_KEY
            })

            return "Successfully update.";
        } catch (error) {
            request.error("Error : ", error)
        }
    })

    this.on('updateProductPrice', async (request, response) => {
        const {
            NODE_KEY,
            PRICE
        } = request.data;

        try {
            const objTansaction = cds.tx(request);
            await objTansaction.update(ProductSrv).with({
                PRICE: PRICE
            }).where({
                NODE_KEY: NODE_KEY
            })

            return "Successfully update.";
        } catch (error) {
            request.error("Error : ", error)
        }
    })

    this.on('deleteEmployee', async (request, response) => {
        const {
            ID
        } = request.data;

        try {
            const objTansaction = cds.tx(request);
            await objTansaction.delete(EmployeeSrv).where({
                ID: ID
            })

            return "Successfully deleted.";
        } catch (error) {
            request.error("Error : ", error)
        }
    })

    // Implementation of custom function

    this.on('getHighestSalariedEmployees', async (request, response) => {

        try {

            // Step - 1 : Create an object for the transaction

            const transaction = cds.tx(request);


            // Step - 2 : Get salaries of an employee using Transaction object

            const response = await transaction.read(EmployeeSrv).orderBy({

                salaryAmount: 'desc'

            }).limit(10);


            // Step - 3 : Display the employee salaries

            return response;


        } catch (error) {

            request.error("Error : ", error);

        }

    })

    // Implementation of custom function

    this.on('getHeighestPricedProduct', async (request, response) => {

        try {

            // Step - 1 : Create an object for the transaction

            const transaction = cds.tx(request);


            // Step - 2 : Get highest priced product

            const response = await transaction.read(ProductSrv).orderBy({

                PRICE: 'desc'

            }).limit(1);


            // Step - 3 : Display the highest priced product

            return response;


        } catch (error) {

            request.error("Error : ", error);

        }

    })

    this.on('discountPrice', async (request, response) => {
        try {
            // Step-1 : Get the parameter form the entity
            const ID = request.params[0];

            // Step-2 : Creating object for transaction service using request
            const transaction = cds.tx(request);

            // Step-3 : Update the purchase order service
            await transaction.update(PurchaseOrderSrv).with({
                GROSS_AMOUNT: {
                    '-=': 1000
                },
                NET_AMOUNT: {
                    '-=': 800
                },
                TAX_AMOUNT: {
                    '-=': 200
                }
            }).where(ID);

            const updatePOInfo = await transaction.read(PurchaseOrderSrv);

            return updatePOInfo;

        } catch (error) {
            return "Error : " + error.toString();
        }
    });

    this.on('increasePrice', async (request) => {
        try {
            const ID = request.params[0];

            const transaction = cds.tx(request);

            await transaction.update(ProductSrv).with({
                PRICE: {
                    '*=': 1.10
                }
            }).where(ID);

            return await transaction.read(ProductSrv);

            const updatePrice = await transaction.read(ProductSrv);

            return updatePrice;

        } catch (error) {
            return "Error : " + error.toString();
        }
    });

    this.on('top_20_product', ProductSrv, async (request) => {
        try {

            const transaction = cds.tx(request);

            const products = await transaction.read(ProductSrv)
                .orderBy('PRICE desc')
                .limit(20);

            return products;

        } catch (error) {
            return request.error(500, "Error : " + error.toString());
        }
    });

    this.on('increaseSalary', async (request) => {
        try {
            const ID = request.params[0];

            const transaction = cds.tx(request);

            await transaction.update(EmployeeSrv).with({
                salaryAmount: {
                    '*=': 1.15
                }
            }).where(ID);

            return await transaction.read(EmployeeSrv);

            const updatePrice = await transaction.read(EmployeeSrv)

            return updatePrice;
        } catch (error) {
            return "Error : " + error.toString();
        }
    });


    this.on('Top20PaidEmployee', EmployeeSrv, async (request) => {
        try {

            const transaction = cds.tx(request);

            const employee = await transaction.read(EmployeeSrv)
                .orderBy('salaryAmount desc')
                .limit(20);

            return employee;

        } catch (error) {
            return request.error(500, "Error : " + error.toString());
        }
    });

    this.on('largestOrder', async (request, response) => {
        try {

            const transaction = cds.tx(request);

            const reply = await transaction.read(PurchaseOrderSrv).orderBy({
                GROSS_AMOUNT: 'desc'
            }).limit(5);
            return reply;
        } catch (error) {
            return "Error : " + error.toString();
        }

    })

    // Utility Variables

    this.on('getUtilities', async (request, response) => {

        let vUUID = uuid(), vPackageContent = null, vInput = "%E0%A4%A", uri, dirExists = false, isFileExists = false;

        // Exists
        if (exists('srv/request.http')) {
            isFileExists = true;
        }

        // Is directory exists or not
        if (isdir('app')) {
            dirExists = true;
        }

        // Decode URI
        try {
            uri = decodeURI(vInput);

            // Make Directory
            await mkdir('srv/lib')
        } catch {
            uri = vInput;
        }

        vPackageContent = await read('package.json');


        // Final Value
        var finalValue = {
            uuid: vUUID,
            uri: uri,
            isFileExists: isFileExists,
            dirExists: dirExists,
            packageInfo: vPackageContent
        }

        return finalValue;

    });

});