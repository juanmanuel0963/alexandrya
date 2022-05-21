import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'hola_mundo': 'Hello world',
          'loading': 'Loading...',
          'home': 'Home',
          'login': 'Login',
          'register': 'Register',
          'password': 'Password',
          'not_have_account': 'Does not have an account?',
          'enter_password': 'Please Enter Password',
          'password_not_match': 'Passwords does not match',
          'enter_email': 'Please Enter E-mail',
          'retype_password': 'Retype Password',
        },
        'es': {
          'hola_mundo': 'Hola mundo',
          'loading': 'Cargando...',
          'home': 'Inicio',
          'login': 'Ingresar',
          'register': 'Registro',
          'password': 'Contraseña',
          'not_have_account': 'No tiene una cuenta?',
          'enter_password': 'Por favor ingrese una contraseña',
          'password_not_match': 'La contraseña no coincide',
          'enter_email': 'Por favor ingrese un E-mail',
          'retype_password': 'Ingrese nuevamente la contraseña',
        },
        'pt': {
          'hola_mundo': 'Olá mundo',
          'loading': 'Carregando...',
          'home': 'Começo',
          'login': 'Entrar',
          'register': 'Registro',
          'password': 'Senha',
          'not_have_account': 'Não tem uma conta?',
          'enter_password': 'Por favor insira uma senha',
          'password_not_match': 'Senha não corresponde',
          'enter_email': 'Por favor, insira um E-mail',
          'retype_password': 'Digite novamente a senha',
        },
        'fr': {
          'hola_mundo': 'Salut monde',
          'loading': 'Chargement...',
          'home': 'Début',
          'login': 'Entrer',
          'register': 'Enregistrement',
          'password': 'Mot de passe',
          'not_have_account': 'Vous n' 'avez pas de compte?',
          'enter_password': 'Veuillez entrer un mot de passe',
          'password_not_match': 'Le mot de passe ne correspond pas',
          'enter_email': 'Veuillez saisir un E-mail',
          'retype_password': 'Retaper le mot de passe',
        }
      };
}
