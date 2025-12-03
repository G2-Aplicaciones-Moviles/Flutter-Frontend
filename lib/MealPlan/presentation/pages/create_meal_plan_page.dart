import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/meal_plan_bloc.dart';
import '../bloc/meal_plan_event.dart';
import '../bloc/meal_plan_state.dart';
import '../../data/models/create_meal_plan_request.dart';

class CreateMealPlanPage extends StatefulWidget {
  final int userId;

  const CreateMealPlanPage({super.key, required this.userId});

  @override
  State<CreateMealPlanPage> createState() => _CreateMealPlanPageState();
}

class _CreateMealPlanPageState extends State<CreateMealPlanPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _tagController = TextEditingController();

  final List<String> _tags = [];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final request = CreateMealPlanRequest(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        calories: 0.0,
        carbs: 0.0,
        proteins: 0.0,
        fats: 0.0,
        profileId: null,
        category: _categoryController.text.trim(),
        isCurrent: true,
        tags: _tags,
      );

      context.read<MealPlanBloc>().add(
        CreateMealPlanEvent(widget.userId, request),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MealPlanBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Creación de Plan"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<MealPlanBloc, MealPlanState>(
          listener: (context, state) {
            if (state is MealPlanCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Plan alimenticio creado exitosamente"),
                  backgroundColor: Colors.green,
                ),
              );

              /// 🔥 SOLUCIÓN DEFINITIVA 🔥
              /// Volvemos al MainLayout, NO a la ruta directa
              Navigator.pop(context, true);
            }

            if (state is MealPlanError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is MealPlanLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.restaurant_menu,
                                size: 40, color: Colors.white),
                            SizedBox(height: 8),
                            Text(
                              "MENÚ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text("Nombre",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Ej: Plan Semanal de Nutrición",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      validator: (v) =>
                      v!.trim().isEmpty ? "El nombre es requerido" : null,
                    ),

                    const SizedBox(height: 16),

                    const Text("Descripción",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Describe los objetivos del plan",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      validator: (v) => v!.trim().isEmpty
                          ? "La descripción es requerida"
                          : null,
                    ),

                    const SizedBox(height: 16),

                    const Text("Categoría",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _categoryController,
                      decoration: InputDecoration(
                        hintText: "Ej: Vegetariano, Bajo en sodio",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      validator: (v) => v!.trim().isEmpty
                          ? "La categoría es requerida"
                          : null,
                    ),

                    const SizedBox(height: 16),

                    const Text("Tags",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _tagController,
                            decoration: InputDecoration(
                              hintText: "Ej: Deportista, Familiar",
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onFieldSubmitted: (_) => _addTag(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.add_circle,
                              color: Colors.blue, size: 32),
                          onPressed: _addTag,
                        ),
                      ],
                    ),

                    if (_tags.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: _tags
                            .map((tag) => Chip(
                          label: Text(tag),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () => _removeTag(tag),
                        ))
                            .toList(),
                      ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                        isLoading ? null : () => _submitForm(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                            color: Colors.white)
                            : const Text("Crear Plan Alimenticio"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
