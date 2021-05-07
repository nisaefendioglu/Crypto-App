const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

exports.kayitOlusturuldu = functions.firestore.document('users/{docId}').onCreate((snapshot, context) => {
    admin.firestore().collection("günlük").add({
        "aciklama":"koleksiyona yeni kayıt girildi."
    })
});


exports.kayitSilindi = functions.firestore.document('users/{docId}').onDelete((snapshot, context) => {
    admin.firestore().collection("günlük").add({
        "aciklama":"koleksiyondan kayıt silindi."
    })
});


exports.kayitGuncellendi = functions.firestore.document('users/{docId}').onUpdate((change, context) => {
    admin.firestore().collection("günlük").add({
        "aciklama":"koleksiyondaki kayıt güncellendi."
    })
});


exports.yazmaGerceklesti = functions.firestore.document('users/{docId}').onWrite((change, context) => {
    admin.firestore().collection("günlük").add({
        "aciklama":"koleksiyonda veri ekleme, silme, güncelleme işlemlerinden biri gerçekleşti."
    })
});