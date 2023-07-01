import 'package:database/bloc/events/crud_events.dart';
import 'package:database/bloc/states/crud_states.dart';
import 'package:database/database/note_db_controller.dart';
import 'package:database/models/note.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesBloc extends Bloc<CrudEvent,CrudState>{
  NotesBloc(super.initialState){
    on<CreateEvent>(_createEvent);
    on<ReadEvent>(_readEvent);
    on<UpdateEvent>(_updateEvent);
    on<DeleteEvent>(_deleteEvent);

  }

  final NoteDbController _dbController = NoteDbController();
  List<Note> _notes = <Note>[];

  void _createEvent (CreateEvent event , Emitter<CrudState> emit)async{
    int newRowId = await _dbController.create(event.note);
    if(newRowId!=0){
      event.note.id = newRowId;
      _notes.add(event.note);
      emit(ReadState(_notes));
    }
    emit(ProcessState(processType: ProcessType.create,
        message: newRowId!=0?'Operation completed successfully':'Operation failed',
        status: newRowId!=0));
  }
  void _readEvent(ReadEvent event , Emitter<CrudState> emit)async{
    emit(LoadingState());
    _notes = await _dbController.read();
    emit(ReadState(_notes));
  }
  void _updateEvent (UpdateEvent event , Emitter<CrudState> emit)async{
    bool updated = await _dbController.update(event.note);
    if(updated){
      int index = _notes.indexWhere((element) => element.id == event.note.id );
      if(index !=-1){
        _notes[index] = event.note;
        emit(ReadState(_notes));
      }
    }
    emit(ProcessState(processType: ProcessType.update,
        message: updated?'Operation completed successfully':'Operation failed',
        status: updated));
  }
  void _deleteEvent(DeleteEvent event , Emitter<CrudState>emit)async{
    bool deleted = await _dbController.delete(_notes[event.index].id);
    if(deleted){
      _notes.removeAt(event.index);
      emit(ReadState(_notes));
    }
    emit(ProcessState(processType: ProcessType.delete,
        message: deleted?'Operation completed successfully':'Operation failed',
        status: deleted));
  }

}