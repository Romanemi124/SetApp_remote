//
//  Store.swift
//  SetApp
//
//  Created by Omar Bonilla Varela on 6/5/22.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseAuth
import FirebaseStorage

/*  Clase permite recuparar el usuario e inyectarlo a la variable de entorno que utilizamos en toda la aplicación */
enum Store {
    
    /* Función pasar la referencia de la ruta del usuario */
    static func referenciaUsuario(id: String) -> DocumentReference {
        return Firestore.firestore().collection(Claves.RutaColeccion.usuarios).document(id)
    }
    
    static let rutaUsuarios = Firestore.firestore().collection(Claves.RutaColeccion.usuarios)
    
    /* Buscamos un usuario en la colección de usuarios según su id
     (Result<UsuarioFireBase, Error>) -> () devuelve como resultado un objecto UsuarioFireBase o un Error. Los errores que que devuelvan se tratarán con la clase StoreError */
    static func recuperarUsuarioFB(id: String, completion: @escaping (Result<UsuarioFireBase, Error>) -> ()) {
        
        //        let reference = Firestore
        //            .firestore()
        //            .collection(Claves.RutaColeccion.usuarios)
        //            .document(id)
        
        //Tratamiento de documentos se realiza en la función getDocument()
        getDocument(for: referenciaUsuario(id: id)) { (result) in
            switch result {
            case .success(let data):
                //Se almacena los datos en el diccionario, se da error significa que el usuario no esta autentificado por tanto que no existe o que no se encuentra
                guard let usuarioFb = UsuarioFireBase(documentData: data) else {
                    //Mostramos el error
                    completion(.failure(StoreError.noUser))
                    return
                }
                //Encuentra al usuario y envía el usuario
                completion(.success(usuarioFb))
                //No puede realizar la busqueda debido a un error
            case .failure(let err):
                completion(.failure(err))
            }
        }
        
    }
    
    /* Asignamos los datos del usuario a la base de datos
     _ data: [String: Any] Los datos que se subirán serán de un diccionario
     uid: String id del usuario que se va a añdir los datos
     completion: @escaping (Result<Bool, Error>) -> () devuelve como resultado un booleano o un Error*/
    static func subirDatosFireBase(_ data: [String: Any], id: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        //Subir los datos
        referenciaUsuario(id: id).setData(data, merge: true) { (err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            completion(.success(true))
        }
        
    }
    
    /* Tratamiento de errores en la obtención de un documento
     Result<[String : Any Para crear el diccionario del usuario  en el caso que no hay errores */
    fileprivate static func getDocument(for reference: DocumentReference, completion: @escaping (Result<[String : Any], Error>) -> ()) {
        
        reference.getDocument { (documentSnapshot, err) in
            //No es posible realizar la busqueda
            if let err = err {
                completion(.failure(err))
                return
            }
            
            //No encuentra el documento
            guard let documentSnapshot = documentSnapshot else {
                completion(.failure(StoreError.noDocumentSnapshot))
                return
            }
            
            //No encuentra datos en el documento
            guard let data = documentSnapshot.data() else {
                completion(.failure(StoreError.noSnapshotData))
                return
            }
            //Encunetra datos en el documento
            completion(.success(data))
        }
    }
    
    /* Borrar los datos de los usuarios */
    static func borrarDatosUsuario(id: String, completion: @escaping (Result<Bool,Error>) -> Void) {
        
        referenciaUsuario(id: id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    /* Buscar usuarios */
    /* Buscamos un usuario en la colección de usuarios según su id
     (Result<UsuarioFireBase, Error>) -> () devuelve como resultado un objecto UsuarioFireBase o un Error. Los errores que que devuelvan se tratarán con la clase StoreError */
    static func recuperarTodosUsuarioFB(completion: @escaping (Result<[UsuarioFireBase], Error>) -> ()) {
        
        //        let reference = Firestore
        //            .firestore()
        //            .collection(Claves.RutaColeccion.usuarios)
        //            .document(id)
        
        //Tratamiento de documentos se realiza en la función getDocument()
        rutaUsuarios.getDocuments{ querySnapshot, error in
            
            if let error = error {
                
                print("Error retreiving collection: \(error)")
                completion(.failure(error))
                return
                
            }else{
                
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    completion(.failure(StoreError.noDocumentSnapshot))
                    return
                }

                
                guard let documentsData = querySnapshot?.documents else {
                    
                        print("Error fetching documents: \(error!)")
                        completion(.failure(StoreError.noSnapshotData))
                        return
                }
                
                //Variable que almacena los usuarios de FireBase
                var usuariosFireBase = [UsuarioFireBase]()
                
                //Recorremos los documentos
                for document in documentsData {
                    
                    //Cojemos los datos de un usuario
                    let dict = document.data()
                    
                    
                    //Decodificamos los datos según el diccionario de clase UsuarioFireBase
                    guard let usuarioFb = UsuarioFireBase(documentData: dict) else {
                        //Mostramos el error
                        completion(.failure(StoreError.noUser))
                        return
                    }
                    
                    //Añadimos los usuarios decodificados
                    usuariosFireBase.append(usuarioFb)
                    
                    //Devolvemos los usuarios
                    completion(.success(usuariosFireBase))
                    
                }
                
            }
      
        }
        
    }
    
}
