import 'package:flutter/material.dart';
import 'package:smartlock/ui/home/widget/scheduled_access_page.dart';

class UsersManagerPage extends StatefulWidget {
  const UsersManagerPage({super.key});

  @override
  State<UsersManagerPage> createState() => _UsersManagerPageState();
}

class _UsersManagerPageState extends State<UsersManagerPage> {
  List<Map<String, dynamic>> users = [
    {
      'name': 'Laura Martínez',
      'email': 'laura.martinez@email.com',
      'role': 'Administrador',
      'avatar': 'L',
      'color': Colors.purple,
      'fingerprint': true,
      'pin': true,
      'lastAccess': 'Hace 2 horas',
    },
    {
      'name': 'David García',
      'email': 'david.garcia@email.com',
      'role': 'Usuario',
      'avatar': 'D',
      'color': Colors.blue,
      'fingerprint': true,
      'pin': false,
      'lastAccess': 'Hace 5 horas',
    },
    {
      'name': 'María López',
      'email': 'maria.lopez@email.com',
      'role': 'Usuario',
      'avatar': 'M',
      'color': Colors.green,
      'fingerprint': false,
      'pin': true,
      'lastAccess': 'Ayer',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3A8A), Color(0xFFF8FAFC)],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar personalizado
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Gestión de Usuarios',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${users.length} usuarios',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Lista de usuarios
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return _buildUserCard(users[index], index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddUserDialog(),
        backgroundColor: Color(0xFF3B82F6),
        icon: Icon(Icons.person_add),
        label: Text('Agregar Usuario'),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: user['color'],
              radius: 30,
              child: Text(
                user['avatar'],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            title: Text(
              user['name'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  user['email'],
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildBadge(
                      user['role'],
                      user['role'] == 'Administrador'
                          ? Colors.orange
                          : Colors.blue,
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.access_time, size: 12, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      user['lastAccess'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton(
              icon: Icon(Icons.more_vert),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 12),
                      Text('Editar'),
                    ],
                  ),
                  onTap: () => _showEditUserDialog(user, index),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.security, size: 20),
                      SizedBox(width: 12),
                      Text('Permisos'),
                    ],
                  ),
                  onTap: () => _showPermissionsDialog(user),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.schedule, size: 20),
                      SizedBox(width: 12),
                      Text('Horario de Acceso'),
                    ],
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ScheduledAccessPage(user: user))),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 12),
                      Text('Eliminar', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  onTap: () => _showDeleteDialog(index),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: _buildAccessMethod(
                    icon: Icons.fingerprint,
                    label: 'Huella',
                    enabled: user['fingerprint'],
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildAccessMethod(
                    icon: Icons.dialpad,
                    label: 'PIN',
                    enabled: user['pin'],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAccessMethod({
    required IconData icon,
    required String label,
    required bool enabled,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: enabled
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled
              ? Colors.green.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: enabled ? Colors.green : Colors.grey),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: enabled ? Colors.green.shade700 : Colors.grey.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            size: 14,
            color: enabled ? Colors.green : Colors.grey,
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String selectedRole = 'Usuario';
    bool enableFingerprint = false;
    bool enablePIN = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.person_add, color: Color(0xFF3B82F6)),
              SizedBox(width: 10),
              Text('Agregar Usuario'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Rol',
                    prefixIcon: Icon(Icons.security),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['Administrador', 'Usuario'].map((role) {
                    return DropdownMenuItem(value: role, child: Text(role));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),
                SizedBox(height: 16),
                SwitchListTile(
                  title: Text('Habilitar Huella Digital'),
                  secondary: Icon(Icons.fingerprint),
                  value: enableFingerprint,
                  activeColor: Color(0xFF3B82F6),
                  onChanged: (value) {
                    setState(() {
                      enableFingerprint = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Habilitar PIN'),
                  secondary: Icon(Icons.dialpad),
                  value: enablePIN,
                  activeColor: Color(0xFF3B82F6),
                  onChanged: (value) {
                    setState(() {
                      enablePIN = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3B82F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty) {
                  final newUser = {
                      'name': nameController.text,
                      'email': emailController.text,
                      'role': selectedRole,
                      'avatar': nameController.text[0].toUpperCase(),
                      'color': Colors
                          .primaries[users.length % Colors.primaries.length],
                      'fingerprint': enableFingerprint,
                      'pin': enablePIN,
                      'lastAccess': 'Nunca',
                    };
                  // Llama al setState de la página principal para redibujar la lista.
                  this.setState(() {
                    users.add(newUser);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 12),
                          Text('Usuario agregado exitosamente'),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              child: Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditUserDialog(Map<String, dynamic> user, int index) {
    final nameController = TextEditingController(text: user['name']);
    final emailController = TextEditingController(text: user['email']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.edit, color: Color(0xFF3B82F6)),
            SizedBox(width: 10),
            Text('Editar Usuario'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3B82F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              setState(() {
                users[index]['name'] = nameController.text;
                users[index]['email'] = emailController.text;
                users[index]['avatar'] = nameController.text[0].toUpperCase();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Usuario actualizado'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showPermissionsDialog(Map<String, dynamic> user) {
    bool fingerprint = user['fingerprint'];
    bool pin = user['pin'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.security, color: Color(0xFF3B82F6)),
              SizedBox(width: 10),
              Text('Permisos de Acceso'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user['name'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              SwitchListTile(
                title: Text('Huella Digital'),
                secondary: Icon(Icons.fingerprint),
                value: fingerprint,
                activeColor: Color(0xFF3B82F6),
                onChanged: (value) {
                  setState(() {
                    fingerprint = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Código PIN'),
                secondary: Icon(Icons.dialpad),
                value: pin,
                activeColor: Color(0xFF3B82F6),
                onChanged: (value) {
                  setState(() {
                    pin = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3B82F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                setState(() {
                  user['fingerprint'] = fingerprint;
                  user['pin'] = pin;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Permisos actualizados'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 10),
            Text('Eliminar Usuario'),
          ],
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar a ${users[index]['name']}? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              setState(() {
                users.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Usuario eliminado'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
