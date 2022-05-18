//
//  ForgotPasswordView.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-19.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//
import SwiftUI

struct CambiarPasswordView: View {
    
    @EnvironmentObject var estadoUsuario: EstadoAutentificacionUsuario
    @State var usuarioValidacion: Validacion = Validacion()
    @Environment(\.presentationMode) var presentationMode
    
    /* Variables para la gestión de las alert */
    //Controla que se muestre o no el alert
    @State var showAlert: Bool =  false
    //Elegir el tipo de alert que se va a mostrar
    @State var alertType: TipoAlert? = nil
    //El mesnaje que mostrará en los alert de error
    @State private var errorString: String?
    
    var body: some View {
        //a@gmail.com
        NavigationView {
            
            VStack {
                
                TextField("Introduce tu correo electrónico", text: $usuarioValidacion.email).autocapitalization(.none).keyboardType(.emailAddress)
                
                Button(action: {
                    
                    Autentificacion.cambiarPassword(email:  self.usuarioValidacion.email){ (result) in
                        switch result {
                        case .failure(let error):
                            //Elegimos el texto de error a mostrar, controlamos el tipo de error
                            switch error.localizedDescription{
                                //En caso que el ya exista el email introducido
                            case ErroresString.ErroresCambiarContraseña.noExisteUsuario:
                                self.errorString = ErroresString.ErroresCambiarContraseña.noExisteUsuarioTraduccion
                                //Mostramos cualquier tipo de error sucedido
                            default:
                                self.errorString = error.localizedDescription
                            }
                            //Seleccionamos el tipo de alert a mostrar
                            alertType = .error
                        case .success( _):
                            //Cuando haya cambiado de contraseña se cerrará la sesión
                            print("Exito")
                            alertType = .sucess
                        }
                        self.showAlert = true
                    }
                }) {
                    Text("Cambiar")
                        .frame(width: 200)
                        .padding(.vertical, 15)
                        .background(Color.green)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    //.opacity(user.isEmailValid(_email: user.email) ? 1 : 0.75)
                        .opacity(usuarioValidacion.estaValidoEmail(_email: usuarioValidacion.email) ? 1 : 0.75)
                }
                .disabled(!usuarioValidacion.estaValidoEmail(_email: usuarioValidacion.email))
                Spacer()
            }.padding(.top)
                .frame(width: 300)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .navigationBarTitle("Petición cambio de contraseña", displayMode: .inline)
                .navigationBarItems(trailing: Button("Dismiss") {
                    self.presentationMode.wrappedValue.dismiss()
                })
                .alert(isPresented: $showAlert, content: {
                    getAlert()
                })
        }
    }
    
    /* Mostrar alert */
    func getAlert()-> Alert{
        
        /* Devolverá el alert personalizado con el valor de las variables */
        switch alertType{
            
        case .error:
            return Alert(title: Text("Notificación"), message: Text(self.errorString!), dismissButton: .default(Text("Ok"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        case .sucess:
            return Alert(title: Text("Notificación"), message: Text("Petición de cambio de contraseña aceptado. Se te ha enviado un correo para cambiarla"), dismissButton: .default(Text("Ok"), action: {
                Autentificacion.cerrarSesion{ result in
                    print("Cerrando sesión...")
                }
            }))
        default:
            return Alert(title: Text("Error"))
        }
        
    }
}


struct CambiarPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CambiarPasswordView()
    }
}