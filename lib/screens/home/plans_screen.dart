import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/primary_button.dart';
import 'create_plan_screen.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  final List<PlanItem> _plans = [
    PlanItem(title: 'Menú 1', recipes: 6),
    PlanItem(title: 'Menú 2', recipes: 7),
    PlanItem(title: 'Menú 3', recipes: 6),
    PlanItem(title: 'Menú 4', recipes: 7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Creación y Gestión de Planes'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            const Text(
              'Planes Alimenticios creados por ti',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text('Lista de planes', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),

            // GRID DE PLANES
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _plans.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: .78,
              ),
              itemBuilder: (context, index) {
                final plan = _plans[index];
                return _PlanCard(
                  plan: plan,
                  onEdit: () => _editPlan(plan),
                  onDuplicate: () => _duplicatePlan(plan),
                  onView: () => _viewPlan(plan),
                  onDelete: () => _deletePlan(index),
                );
              },
            ),

            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Crear Nuevo Plan Alimenticio',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreatePlanScreen()),
                );
                // En un caso real, refrescarías la lista aquí
              },
            ),
          ],
        ),
      ),
    );
  }

  // Acciones (placeholder)
  void _editPlan(PlanItem p) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editar: ${p.title}')),
    );
  }

  void _duplicatePlan(PlanItem p) {
    setState(() => _plans.add(PlanItem(title: '${p.title} (copia)', recipes: p.recipes)));
  }

  void _viewPlan(PlanItem p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(p.title),
        content: Text('Este plan tiene ${p.recipes} recetas.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  void _deletePlan(int index) {
    setState(() => _plans.removeAt(index));
  }
}

class PlanItem {
  final String title;
  final int recipes;
  const PlanItem({required this.title, required this.recipes});
}

class _PlanCard extends StatelessWidget {
  final PlanItem plan;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const _PlanCard({
    required this.plan,
    required this.onEdit,
    required this.onDuplicate,
    required this.onView,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onView,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // “Imagen” con degradado para no depender de assets
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.restaurant_menu, size: 48, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),

              // Título + recetas
              Align(
                alignment: Alignment.centerLeft,
                child: Text(plan.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('${plan.recipes} recetas', style: const TextStyle(color: Colors.grey)),
              ),
              const Spacer(),

              // Acciones pequeñas como en tu mock
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _iconSmall(context, Icons.edit, tooltip: 'Editar', onTap: onEdit),
                  const SizedBox(width: 6),
                  _iconSmall(context, Icons.copy_all, tooltip: 'Duplicar', onTap: onDuplicate),
                  const SizedBox(width: 6),
                  _iconSmall(context, Icons.visibility, tooltip: 'Ver', onTap: onView),
                  const SizedBox(width: 6),
                  _iconSmall(context, Icons.delete, color: Colors.red, tooltip: 'Eliminar', onTap: onDelete),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconSmall(BuildContext context, IconData icon,
      {Color? color, String? tooltip, required VoidCallback onTap}) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: color ?? Colors.black87),
        ),
      ),
    );
  }
}
