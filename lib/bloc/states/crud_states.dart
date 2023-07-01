import '../../models/note.dart';

class CrudState{}

enum ProcessType{
  create , update , delete
}
class LoadingState extends CrudState{}

class ProcessState extends CrudState{
  final String message ;
  final bool status;
  final ProcessType processType;
  ProcessState({
    required this.processType,
    required this.message,
    required this.status
});
}

class ReadState extends CrudState{
  final List<Note> notes ;
  ReadState(this.notes);
}