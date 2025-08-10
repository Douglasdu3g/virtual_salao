# Virtual Salão 💈📱

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Google Maps](https://img.shields.io/badge/Google%20Maps-4285F4?style=for-the-badge&logo=google-maps&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)

**🚀 Aplicativo Flutter para conectar clientes a barbeiros próximos usando geolocalização e Google Maps**

[Funcionalidades](#-funcionalidades) • [Tecnologias](#-tecnologias) • [Instalação](#-instalação) • [API](#-api-reference) • [Contribuição](#-contribuição)

</div>

---

## 📖 Sobre o Projeto

O **Virtual Salão** é um aplicativo mobile desenvolvido em Flutter que revolutiona a forma como clientes encontram barbeiros. Utilizando tecnologias modernas como Firebase, Google Maps e geolocalização, o app oferece uma experiência completa para agendar serviços de barbearia.

### 🎯 Principais Objetivos
- Conectar clientes a barbeiros próximos através de geolocalização
- Facilitar o agendamento de serviços de barbearia
- Oferecer uma interface intuitiva e moderna
- Integrar mapas interativos para visualização das localizações

---

## ✨ Funcionalidades

### 🔐 **Sistema de Autenticação**
- ✅ Login com email e senha
- ✅ Criação de contas
- ✅ Login anônimo para testes
- ✅ Logout seguro
- ✅ AuthWrapper para controle de sessão

### 🗺️ **Mapa Interativo**
- ✅ Integração com Google Maps
- ✅ Marcadores personalizados para barbeiros
- ✅ Localização do usuário em tempo real
- ✅ Cálculo de distância
- ✅ Navegação para localização dos barbeiros

### 👨‍💼 **Gestão de Barbeiros**
- ✅ Cadastro completo de barbeiros
- ✅ Upload de fotos de perfil
- ✅ Especialidades e avaliações
- ✅ Status de disponibilidade
- ✅ Informações de contato

### 📱 **Interface Responsiva**
- ✅ Design Material Design
- ✅ Temas consistentes
- ✅ Animações suaves
- ✅ Feedback visual para ações do usuário

### 🔔 **Notificações e Feedback**
- ✅ SnackBars para feedback
- ✅ Estados de carregamento
- ✅ Tratamento de erros
- ✅ Mensagens de sucesso/erro

---

## 🛠️ Tecnologias

### **Frontend**
- **Flutter 3.29.2** - Framework principal
- **Dart 3.7.2** - Linguagem de programação

### **Backend & Services**
- **Firebase Core 2.32.0** - Plataforma backend
- **Firebase Auth 4.20.0** - Autenticação
- **Cloud Firestore 4.17.5** - Banco de dados NoSQL
- **Firebase Storage 11.7.7** - Armazenamento de arquivos

### **Mapas & Geolocalização**
- **Google Maps Flutter 2.12.1** - Mapas interativos
- **Geolocator 10.1.1** - Serviços de geolocalização

### **Funcionalidades Adicionais**
- **Image Picker 1.0.7** - Seleção de imagens
- **HTTP 1.2.2** - Requisições HTTP
- **SQLite 2.3.2** - Banco local
- **Path Provider 2.1.2** - Gerenciamento de diretórios

### **Ferramentas de Desenvolvimento**
- **Flutter Lints 5.0.0** - Análise de código
- **Android Gradle Plugin 8.5.1** - Build Android
- **Kotlin 2.0.0** - Linguagem para Android

---

## 🏗️ Arquitetura

```
lib/
├── main.dart                     # Ponto de entrada da aplicação
├── firebase_options.dart         # Configurações do Firebase
├── models/                       # Modelos de dados
│   ├── barber.dart              # Modelo do barbeiro
│   ├── localizacao.dart         # Modelo de localização
│   ├── agendamento.dart         # Modelo de agendamento
│   └── services/                # Serviços de negócio
│       ├── auth_service.dart    # Serviço de autenticação
│       ├── firebase_service.dart # Serviço do Firebase
│       ├── database_service.dart # Serviço de banco de dados
│       ├── barber_service.dart  # Serviço de barbeiros
│       ├── location_service.dart # Serviço de geolocalização
│       └── api_key.dart         # Chaves de API
├── ui/                          # Interface do usuário
│   ├── screens/                 # Telas da aplicação
│   │   ├── login_screen.dart    # Tela de login
│   │   ├── home_screen.dart     # Tela inicial
│   │   ├── mapa_screen.dart     # Tela do mapa
│   │   ├── cadastro_barbeiro_screen.dart # Cadastro de barbeiros
│   │   ├── barbeiro_detalhes_screen.dart # Detalhes do barbeiro
│   │   └── agendamento_screen.dart # Tela de agendamento
│   ├── styles/                  # Estilos e temas
│   │   └── colors.dart          # Paleta de cores
│   └── widget/                  # Widgets reutilizáveis
│       └── barber_widget.dart   # Widget do barbeiro
└── utils/                       # Utilitários
    └── formatter.dart           # Formatadores de dados
```

---

## 🚀 Instalação

### **Pré-requisitos**

1. **Flutter SDK 3.29.2+**
   ```bash
   flutter --version
   ```

2. **Android Studio** ou **VS Code** com extensões Flutter
3. **Emulador Android** ou **dispositivo físico**
4. **Conta Google Cloud** com Google Maps API habilitada
5. **Projeto Firebase** configurado

### **1. Clone o Repositório**
```bash
git clone https://github.com/seu-usuario/virtual_salao.git
cd virtual_salao
```

### **2. Instale as Dependências**
```bash
flutter clean
flutter pub get
```

### **3. Configuração Firebase**

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
2. Adicione o arquivo `google-services.json` em `android/app/`
3. Configure as regras do Firestore:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /barbeiros/{document} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### **4. Configuração Google Maps**

#### **Android**
1. Crie/edite `android/secrets.properties`:
```properties
MAPS_API_KEY=SUA_API_KEY_AQUI
```

2. Crie `android/local.defaults.properties`:
```properties
MAPS_API_KEY=DEFAULT_API_KEY
```

#### **iOS**
Atualize `ios/Runner/AppDelegate.swift`:
```swift
GMSServices.provideAPIKey("SUA_API_KEY_AQUI")
```

#### **Web**
Atualize `web/index.html`:
```html
<script>
  // ... código do Google Maps com sua API key
  key: "SUA_API_KEY_AQUI",
</script>
```

### **5. Configuração de Permissões**

#### **Android** (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA" />
```

### **6. Execute o Projeto**
```bash
flutter run
```

---

## 🔑 Configurações Críticas

### **Versões Android**
```kotlin
android {
    compileSdk = 35
    minSdk = 23
    targetSdk = 35
}
```

### **Plugins Essenciais**
```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.android.libraries.mapsplatform.secrets-gradle-plugin")
}
```

### **Dependências Firebase**
```kotlin
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.16.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-storage")
    implementation("com.google.firebase:firebase-auth")
    implementation("androidx.multidex:multidex:2.0.1")
}
```

---

## 📊 API Reference

### **Estrutura do Barbeiro**
```dart
class Barbeiro {
  final String id;
  final String nome;
  final List<String> especialidades;
  final double avaliacao;
  final Localizacao localizacao;
  final bool disponivelAgora;
  final String contato;
  final String fotoPerfil;
}
```

### **Estrutura da Localização**
```dart
class Localizacao {
  final double latitude;
  final double longitude;
}
```

### **Serviços Principais**

#### **AuthService**
```dart
// Login com email e senha
Future<UserCredential?> signInWithEmailAndPassword(String email, String password)

// Criar conta
Future<UserCredential?> createUserWithEmailAndPassword(String email, String password)

// Login anônimo
Future<UserCredential?> signInAnonymously()

// Logout
Future<void> signOut()
```

#### **FirebaseService**
```dart
// Adicionar barbeiro
Future<String> adicionarBarbeiro(Barbeiro barbeiro, {File? imagemPerfil})

// Buscar barbeiros
Stream<List<Barbeiro>> getBarbeiros()

// Buscar barbeiro específico
Future<Barbeiro?> getBarbeiro(String id)
```

#### **LocationService**
```dart
// Obter localização atual
static Future<Localizacao> getCurrentLocation()

// Calcular distância
static double calculateDistance(double lat1, double lon1, double lat2, double lon2)
```

---

## 🎨 Design System

### **Paleta de Cores**
```dart
class AppColors {
  static const Color blue = Color(0xFF2196F3);
  static const Color darkBlue = Color(0xFF1976D2);
  static const Color facebookBlue = Color(0xFF1877F2);
  static const Color lightGray = Color(0xFFF5F5F5);
}
```

### **Tipografia**
- **Heading**: FontWeight.bold, 20-24px
- **Subtitle**: FontWeight.w500, 16-18px
- **Body**: FontWeight.normal, 14-16px
- **Caption**: FontWeight.w400, 12-14px

---

## 📱 Telas do Aplicativo

### **1. Login Screen**
- Autenticação com email/senha
- Login anônimo
- Integração com redes sociais (placeholder)
- Recuperação de senha

### **2. Home Screen**
- Lista de barbeiros próximos
- Barra de pesquisa
- Navegação para mapa
- Menu de opções

### **3. Mapa Screen**
- Google Maps interativo
- Marcadores dos barbeiros
- Localização do usuário
- Modal com detalhes dos barbeiros

### **4. Cadastro Barbeiro Screen**
- Formulário completo
- Upload de foto
- Geolocalização automática
- Validação de dados

### **5. Barbeiro Detalhes Screen**
- Informações completas
- Avaliações e especialidades
- Opções de contato
- Botão de agendamento

---

## 🧪 Testes

### **Executar Testes**
```bash
flutter test
```

### **Testes Implementados**
- Testes unitários para serviços
- Testes de widget para componentes
- Testes de integração para fluxos principais

---

## 🚨 Troubleshooting

### **Problemas Comuns**

#### **Google Maps não aparece**
```bash
# Verifique a API key
flutter clean
flutter pub get
# Recompile o projeto
```

#### **Erro de build Android**
```bash
# Limpe o projeto
flutter clean
cd android && ./gradlew clean
cd .. && flutter pub get
```

#### **Permissões de localização**
- Verifique se as permissões estão no AndroidManifest.xml
- Teste em dispositivo físico, não emulador

---

## 📈 Performance

### **Otimizações Implementadas**
- ✅ Lazy loading de imagens
- ✅ Cache de dados do Firebase
- ✅ Compressão de imagens
- ✅ Debounce em pesquisas
- ✅ Pagination para listas grandes

### **Métricas de Performance**
- **Tempo de inicialização**: < 3s
- **Carregamento do mapa**: < 2s
- **Upload de imagens**: < 5s
- **Tamanho do APK**: ~100MB

---

## 🔒 Segurança

### **Medidas Implementadas**
- 🔐 Autenticação Firebase
- 🔐 Regras de segurança Firestore
- 🔐 API keys protegidas
- 🔐 Validação de entrada de dados
- 🔐 HTTPS para todas as requisições

---

## 🌐 Deploy

### **Android (Play Store)**
```bash
flutter build apk --release
# ou
flutter build appbundle --release
```

### **iOS (App Store)**
```bash
flutter build ios --release
```

---

## 📝 Changelog

### **v1.0.0** (Atual)
- ✅ Sistema de autenticação completo
- ✅ Integração Google Maps
- ✅ Cadastro de barbeiros
- ✅ Geolocalização
- ✅ Upload de imagens

### **Próximas Versões**
- 🔄 v1.1.0: Sistema de agendamento
- 🔄 v1.2.0: Chat em tempo real
- 🔄 v1.3.0: Pagamentos integrados
- 🔄 v1.4.0: Notificações push

---

## 🤝 Contribuição

### **Como Contribuir**

1. **Fork** o projeto
2. **Crie** uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. **Push** para a branch (`git push origin feature/AmazingFeature`)
5. **Abra** um Pull Request

### **Padrões de Código**
- Use **dart formatter** antes de commits
- Siga **naming conventions** do Dart
- Adicione **comentários** em código complexo
- Escreva **testes** para novas funcionalidades

---

## 📄 Licença

Este projeto está sob a licença **MIT**. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👥 Autores

- **Douglas** - *Desenvolvedor Principal* - [@Douglasdu3g](https://github.com/Douglasdu3g)

---

## 🙏 Agradecimentos

- [Flutter Team](https://flutter.dev) - Framework incrível
- [Firebase](https://firebase.google.com) - Backend como serviço
- [Google Maps](https://developers.google.com/maps) - Serviços de mapas
- [Unsplash](https://unsplash.com) - Imagens de placeholder

---

## 📞 Suporte

- 📧 **Email**: douglas@example.com
- 🐛 **Issues**: [GitHub Issues](https://github.com/seu-usuario/virtual_salao/issues)
- 💬 **Discussões**: [GitHub Discussions](https://github.com/seu-usuario/virtual_salao/discussions)

---

<div align="center">

**⭐ Se este projeto te ajudou, considere dar uma estrela! ⭐**

![GitHub stars](https://img.shields.io/github/stars/seu-usuario/virtual_salao?style=social)
![GitHub forks](https://img.shields.io/github/forks/seu-usuario/virtual_salao?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/seu-usuario/virtual_salao?style=social)

</div>
