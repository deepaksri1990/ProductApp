import { LightningElement, wire, track, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getProductDetails from '@salesforce/apex/ProductBackupCtrl.getProductDetails';

export default class BackupProductCmp extends LightningElement {
    @track productWrapper;
    @api recordId;
    @track error;

    @track prdCreatedDate; 
    @track prdCreatedTime;

    @wire(getProductDetails,{recordId: '$recordId'})  
    prodDetails({error, data}){
        if(data){
            const options = {
                year: 'numeric', month: 'numeric', day: 'numeric',
                hour: '2-digit', minute: '2-digit', hour2:false
              };
              let dataParse = data;
              if ( dataParse.prodCreatedDate ) {
                console.log('dataParse.prodCreatedDate@@@@'+dataParse.prodCreatedDate);
                let dt = new Date( dataParse.prodCreatedDate );
                this.prdCreatedDate = new Intl.DateTimeFormat( 'en-US' ).format( dt );
                this.prdCreatedTime = new Date(dataParse.prodCreatedDate).toLocaleTimeString([], {hour: '2-digit', minute: '2-digit', hour12:false});

                console.log('dataParse.prdCreatedTimeNew@@@@'+this.prdCreatedTime);
            }
            
            this.productWrapper = data;
            this.error = undefined;
        }else{
            this.error = error;
            this.productWrapper = undefined;
        }
    }
    
}