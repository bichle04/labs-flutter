import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/delete_todo_usecase.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/toggle_todo_usecase.dart';
import '../state/todo_state.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/todo_item_widget.dart';

/// Main Todo Page - StatefulWidget for local state management
/// Following Single Responsibility Principle (SRP)
/// Open/Closed Principle (OCP) - open for extension via dependency injection
class TodoPage extends StatefulWidget {
  final GetTodosUseCase getTodosUseCase;
  final AddTodoUseCase addTodoUseCase;
  final ToggleTodoUseCase toggleTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;

  const TodoPage({
    super.key,
    required this.getTodosUseCase,
    required this.addTodoUseCase,
    required this.toggleTodoUseCase,
    required this.deleteTodoUseCase,
  });

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> with TickerProviderStateMixin {
  TodoState _state = TodoState.initial();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTodos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTodos() async {
    setState(() {
      _state = _state.copyWithLoading();
    });

    try {
      final todos = await widget.getTodosUseCase.execute();
      setState(() {
        _state = _state.copyWithTodos(todos);
      });
    } catch (e) {
      setState(() {
        _state = _state.copyWithError(e.toString());
      });
    }
  }

  Future<void> _addTodo() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => const AddTodoDialog(),
    );

    if (result == null) return;

    final newTodo = TodoEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: result['title']!,
      description: result['description']!.isEmpty
          ? null
          : result['description'],
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    await widget.addTodoUseCase.execute(newTodo);
    await _loadTodos();
  }

  Future<void> _toggleTodo(String id) async {
    await widget.toggleTodoUseCase.execute(id);
    await _loadTodos();
  }

  Future<void> _deleteTodo(String id) async {
    await widget.deleteTodoUseCase.execute(id);
    await _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.task_alt,
                color: Colors.indigo.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('My Tasks'),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.list_alt, size: 20), text: 'All Tasks'),
            Tab(icon: Icon(Icons.pending_actions, size: 20), text: 'Pending'),
            Tab(icon: Icon(Icons.check_circle, size: 20), text: 'Completed'),
          ],
        ),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTodo,
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }

  Widget _buildBody() {
    if (_state.isLoading && _state.todos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_state.todos.isEmpty) {
      return const EmptyStateWidget();
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildTodoList(_state.todos),
        _buildTodoList(
          _state.todos.where((todo) => !todo.isCompleted).toList(),
        ),
        _buildTodoList(_state.todos.where((todo) => todo.isCompleted).toList()),
      ],
    );
  }

  Widget _buildTodoList(List<TodoEntity> todos) {
    if (todos.isEmpty) {
      return const Center(
        child: Text(
          'No tasks found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTodos,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return TodoItemWidget(
            key: ValueKey(todo.id),
            todo: todo,
            onToggle: () => _toggleTodo(todo.id),
            onDelete: () => _deleteTodo(todo.id),
          );
        },
      ),
    );
  }
}
