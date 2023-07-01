import 'package:database/bloc/bloc/notes_bloc.dart';
import 'package:database/bloc/events/crud_events.dart';
import 'package:database/bloc/states/crud_states.dart';
import 'package:database/extensions/context_extensions.dart';
import 'package:database/prefs/shared_pref_controller.dart';
import 'package:database/widgets/appTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/note.dart';
class NoteScreen extends StatefulWidget {
  const  NoteScreen({Key? key , this.note}) : super(key: key);
  final Note? note ;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController _titleController ;
  late TextEditingController _infoController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title);
    _infoController = TextEditingController(text: widget.note?.info);
  }
  bool  get isNewNote => widget.note==null;
  String get title => isNewNote? context.localizations.create : context.localizations.update;
  @override
  void dispose() {
    // TODO: implement dispose
    _infoController.dispose();
    _titleController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(title),
      ),
      body: BlocListener<NotesBloc , CrudState>(
        listenWhen:(previous , current) =>
          current is ProcessState &&(
          current.processType == ProcessType.create||
              current.processType == ProcessType.update
          ),
        listener:(context , state){
          state as ProcessState;
          context.showSnackBar(message: state.message , error: !state.status);
          if(state.status){
            state.processType == ProcessType.create ?clear():Navigator.pop(context);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField( title: context.localizations.title, icon: Icons.note, textInputType: TextInputType.text, controller: _titleController,),
              SizedBox(height: 10.h,),
              AppTextField(title: context.localizations.info, icon: Icons.info, textInputType: TextInputType.text,controller:_infoController,),
              SizedBox(height: 20.h,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity , 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),

                  ),
                  onPressed: (){
                    _performSave();
                    },
                  child:  Text(context.localizations.save))  ,

            ],
          ),
        ),
      ),
    );
  }
  void _performSave(){
    if(_checkData()) {
      _save();
    }
  }
  bool _checkData(){
    if(_titleController.text.isNotEmpty && _infoController.text.isNotEmpty){
      return true;
    }
    return false;
  }
  void _save()async{
    isNewNote ? BlocProvider.of<NotesBloc>(context).add(CreateEvent(note))
              : BlocProvider.of<NotesBloc>(context).add(UpdateEvent(note));

    // ProcessResponse processResponse;
    // if (isNewNote) {
    //   processResponse = await NoteGetXController.to.create(note);
    // } else {
    //   processResponse = await NoteGetXController.to.updateNote(note);
    // }
    //
    // if(processResponse.success){
    //   isNewNote? clear(): Navigator.pop(context);
    //   context.showSnackBar(message: processResponse.message, error: !processResponse.success);
    // }
  }
  void clear(){
    _titleController.clear();
    _infoController.clear();
  }

  Note get note{
    Note note = isNewNote ?Note():widget.note!;
    note.title = _titleController.text;
    note.info = _infoController.text;
    note.user_id = SharedPrefController().getValueFor<int>(Prefkeys.id.name)!;
    return note;
  }





  }
