import 'package:flutter/material.dart';
import 'package:elcinorch/app/dependencies.dart';
import '../widgets/tag_form_dialog.dart';
import '../widgets/tag_card.dart';

class TagListPage extends StatefulWidget {
  const TagListPage({super.key});

  @override
  State<TagListPage> createState() => _TagListPageState();
}

class _TagListPageState extends State<TagListPage> {
  final tagController = AppDependencies.tagController;

  @override
  void initState() {
    super.initState();

    _loadTags();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadTags() async {
    await tagController.getTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.label),
            const SizedBox(width: 10),
            Text('Tags', style: TextStyle(fontSize: 20))
          ],
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tags',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.tertiary
              ),
            ),
            const SizedBox(height: 10),
            AnimatedBuilder(
              animation: tagController, 
              builder: (context, child) {
                final tags = tagController.tags;

                if(tagController.isLoading && tags.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: CircularProgressIndicator()
                    )
                  );
                }

                if(tags.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.secondary
                    ),
                    child: Column(
                      children: [
                        Text(
                          'No tags yet',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Create your own tag now',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.tertiary
                          )
                        )
                      ]
                    )
                  );
                }
                return Expanded(
                  child: ListView.separated(
                    itemCount: tags.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      final tag = tags[index];
                      return TagCard(
                        tag: tag,
                        onDelete: (context) async {
                          await tagController.delete(tag.id);
                        }
                      );
                    },
                  )
                );
              }
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context, 
                  builder: (context) => TagFormDialog(
                    controller: tagController
                  )
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 76, 175, 142)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Icon(Icons.new_label, color: Theme.of(context).colorScheme.surface),
                    const SizedBox(width: 14),
                    Text(
                      'Create tag',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface
                      )
                    )
                  ]
                ),
              )
            )
          ],
        )
      )
    );
  }
}