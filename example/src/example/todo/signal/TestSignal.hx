package src.example.todo.signal;

import msignal.Signal;
import example.todo.model.TestData;

class TestSignal extends Signal2<TestType, TestEnum>
{

	public function new() 
	{
		super(Dynamic, TestEnum);
	}
	
}