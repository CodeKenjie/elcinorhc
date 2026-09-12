import '../core/database/local/local_database.dart';
import '../features/todo/presentation/controllers/todo_controller.dart';
import '../features/todo/data/data_sources/todo_local_data_source.dart';
import '../features/todo/data/repositories/todo_repository_impl.dart';
import '../features/todo/domain/usecases/add.dart';
import '../features/todo/domain/usecases/get_all.dart';
import '../features/todo/domain/usecases/update.dart';
import '../features/todo/domain/usecases/update_status.dart';
import '../features/todo/domain/usecases/delete.dart';

import '../features/plan/presentation/controller/plan_controller.dart';
import '../features/plan/data/data_sources/plan_local_data_source.dart';
import '../features/plan/data/repositories/plan_repository_impl.dart';
import '../features/plan/domain/usecases/create_plan.dart';
import '../features/plan/domain/usecases/get_plans.dart';
import '../features/plan/domain/usecases/update_plan.dart';
import '../features/plan/domain/usecases/update_plan_status.dart';
import '../features/plan/domain/usecases/delete_plan.dart';

import '../features/journal/presentation/controllers/journal_controller.dart';
import '../features/journal/data/data_sources/journal_local_data_source.dart';
import '../features/journal/data/repositories/journal_repository_impl.dart';
import '../features/journal/domain/usecases/create_journal.dart';
import '../features/journal/domain/usecases/get_journals.dart';
import '../features/journal/domain/usecases/get_journal.dart';
import '../features/journal/domain/usecases/edit_journal.dart';
import '../features/journal/domain/usecases/delete_journal.dart';

import '../features/tag/presentation/controllers/tag_controller.dart';
import '../features/tag/data/data_sources/tag_local_data_source.dart';
import '../features/tag/data/repositories/tag_repository_impl.dart';
import '../features/tag/domain/usecases/journal_tags.dart';
import '../features/tag/domain/usecases/get_tags.dart';
import '../features/tag/domain/usecases/get_tag.dart';
import '../features/tag/domain/usecases/create_tag.dart';
import '../features/tag/domain/usecases/delete_tag.dart';

import '../features/journal/presentation/controllers/journal_tag_controller.dart';
import '../features/journal/data/data_sources/journal_tag_local_data_source.dart';
import '../features/journal/data/repositories/journal_tag_repository_impl.dart';
import '../features/journal/domain/usecases/create_journal_tag.dart';
import '../features/journal/domain/usecases/get_all_journal_tags.dart';
import '../features/journal/domain/usecases/delete_journal_tag.dart';

import '../features/journal/data/data_sources/shared_journal_remote_data_source.dart';
import '../features/journal/data/repositories/shared_journal_repository_impl.dart';
import '../features/journal/domain/usecases/share_journal.dart';
import '../features/journal/domain/usecases/get_shared_journal.dart';
import '../features/journal/domain/usecases/update_shared_journal.dart';
import '../features/journal/domain/usecases/delete_shared_journal.dart';

import '../core/services/auth_service.dart';
import '../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/usecases/user_sign_up.dart';
import '../features/auth/domain/usecases/user_sign_in.dart';
import '../features/auth/domain/usecases/user_sign_out.dart';
import '../features/auth/domain/usecases/get_current_user.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';

import '../features/progress/domain/usecases/get_user_progress.dart';
import '../features/progress/presentation/controllers/progress_controller.dart';

class AppDependencies {
  static final localDatabase = LocalDatabase();
  static final authService = AuthService();

  static final todoLocalDataSource = TodoLocalDataSource(localDatabase);
  static final todoRepository = TodoRepositoryImpl(todoLocalDataSource);
  static final getAllTodoUseCase = GetAll(todoRepository);
  static final addTodoUseCase = Add(todoRepository);
  static final updateTodoUseCase = Update(todoRepository);
  static final updateTodoStatusUseCase = UpdateStatus(todoRepository);
  static final deleteTodoUseCase = Delete(todoRepository);

  static final todoController = TodoController(
    addUseCase: addTodoUseCase, 
    getAllUseCase: getAllTodoUseCase, 
    updateStatusUseCase: updateTodoStatusUseCase, 
    updateUseCase: updateTodoUseCase, 
    deleteUseCase: deleteTodoUseCase
  );

  static final planLocalDataSoure = PlanLocalDataSource(localDatabase);
  static final planRepository = PlanRepositoryImpl(planLocalDataSoure);
  static final getPlansUseCase = GetPlans(planRepository);
  static final createPlanUseCase = CreatePlan(planRepository);
  static final updatePlanUseCase = UpdatePlan(planRepository);
  static final updatePlanStatusUseCase = UpdatePlanStatus(planRepository);
  static final deletePlanUseCase = DeletePlan(planRepository);

  static final planController = PlanController(
    getPlansUseCase: getPlansUseCase, 
    createPlanUseCase: createPlanUseCase, 
    updatePlanUseCase: updatePlanUseCase, 
    updatePlanStatusUseCase: updatePlanStatusUseCase, 
    deletePlanUseCase: deletePlanUseCase
  );


  static final journalLocalDataSource = JournalLocalDataSource(localDatabase);
  static final journalRepository = JournalRepositoryImpl(journalLocalDataSource);
  static final getJournalsUseCase = GetJournals(journalRepository);
  static final getJournalUseCase = GetJournal(journalRepository);
  static final createJournalUseCase = CreateJournal(journalRepository);
  static final editJournalUseCase = EditJournal(journalRepository);
  static final deleteJournalUseCase = DeleteJournal(journalRepository);

  static final sharedJournalRemoteDataSource  = SharedJournalRemoteDataSource(auth: authService);
  static final sharedJournalRepository = SharedJournalRepositoryImpl(sharedJournalRemoteDataSource);
  static final shareJournalUseCase = ShareJournal(sharedJournalRepository);
  static final getSharedJournalUseCase = GetSharedJournal(sharedJournalRepository);
  static final updateSharedJournalUseCase = UpdateSharedJournal(sharedJournalRepository);
  static final deleteSharedJournalUseCase = DeleteSharedJournal(sharedJournalRepository);

  static final journalController = JournalController(
    getJournalUseCase: getJournalUseCase,
    getJournalsUseCase: getJournalsUseCase,
    createJournalUseCase: createJournalUseCase,
    editJournalUseCase: editJournalUseCase,
    deleteJournalUseCase: deleteJournalUseCase,
    shareJournalUseCase: shareJournalUseCase,
    getSharedJournalUseCase: getSharedJournalUseCase,
    updateSharedJournalUseCase: updateSharedJournalUseCase,
    deleteSharedJournalUseCase: deleteSharedJournalUseCase
  );

  static final tagLocalDataSource = TagLocalDataSource(localDatabase);
  static final tagRepository = TagRepositoryImpl(tagLocalDataSource);
  static final getTagsUseCase = GetTags(tagRepository);
  static final getJournalTagsUseCase = GetJournalTags(tagRepository);
  static final getTagUseCase = GetTag(tagRepository);
  static final createTagUseCase = CreateTag(tagRepository);
  static final deleteTagUseCase = DeleteTag(tagRepository);

  static final tagController = TagController(
    getTagsUseCase: getTagsUseCase,
    getJournalTagsUseCase: getJournalTagsUseCase,
    getTagUseCase: getTagUseCase,
    createTagUseCase: createTagUseCase,
    deleteTagUseCase: deleteTagUseCase
  );

  static final journalTagLocalDataSource = JournalTagLocalDataSource(localDatabase);
  static final journalTagRepository = JournalTagRepositoryImpl(journalTagLocalDataSource);
  static final getAllJournalTagsUseCase = GetAllJournalTags(journalTagRepository);
  static final createJournalTagUseCase = CreateJournalTag(journalTagRepository);
  static final deleteJournalTagUseCase = DeleteJournalTag(journalTagRepository);

  static final journalTagController = JournalTagController(
    getJournalTagsUseCase: getAllJournalTagsUseCase,
    createJournalTagUseCase: createJournalTagUseCase,
    deleteJournalTagUseCase: deleteJournalTagUseCase
  );

  static final authRemoteDataSource = AuthRemoteDataSource(auth: authService);
  static final authRepository = AuthRepositoryImpl(authRemoteDataSource);
  static final userSignUpUseCase = UserSignUp(authRepository);
  static final userSignInUseCase = UserSignIn(authRepository);
  static final userSignOutUseCase = UserSignOut(authRepository);
  static final getCurrentUserUseCase = GetCurrentUser(authRepository);

  static final authController = AuthController(
    userSignUpUseCase: userSignUpUseCase, 
    userSignInUseCase: userSignInUseCase, 
    userSignOutUseCase: userSignOutUseCase,
    getCurrentUserUseCase: getCurrentUserUseCase
  );

  static final getUserProgressUseCase = GetUserProgress(
    todoRepository: todoRepository, 
    journalRepository: journalRepository
  );

  static final progressController = ProgressController(
    getUserProgressUseCase: getUserProgressUseCase
  );

}